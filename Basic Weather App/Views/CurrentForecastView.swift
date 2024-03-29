//
//  CurrentForecastView.swift
//  Chase Code Challenge
//
//  Created by Alex on 5/25/23.
//

import Foundation
import SwiftUI


struct CurrentForecastView: View {
    @StateObject var viewModel = WeatherViewModel()
    
    var body: some View {
        NavigationView{
            VStack(alignment: .center) {
                Text(viewModel.weatherModel?.city ?? "")
                    .font(.largeTitle)
                    .bold()
                Text(viewModel.weatherModel?.currentTemp ?? "")
                    .font(.system(size: 72))
                HStack {
                    Text("High: \(viewModel.weatherModel?.highTemp ?? "")")
                    Text("Low: \(viewModel.weatherModel?.lowTemp ?? "")")
                }
                .accessibilityElement(children: .combine)
                VStack {
                    if let imageData = viewModel.weatherModel?.imageData {
                        Image(uiImage: .init(data: imageData)!)
                            .resizable()
                            .frame(width: 80, height: 80)
                    }
                    Text(viewModel.weatherModel?.currentWeather ?? "")
                        .font(.headline)
                        .padding()
                }

                HStack(spacing: 20) {
                    VStack {
                        Image(systemName: "sunrise.fill")
                        Text(viewModel.weatherModel?.sunrise ?? "")
                    }
                    VStack {
                        Image(systemName: "sunset.fill")
                        Text(viewModel.weatherModel?.sunset ?? "")
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button {
                            Task {
                                await viewModel.fetchCurrentLocation()
                            }
                        } label: {
                            Label("Current Location", systemImage: "location")
                        }
                        Button {
                            viewModel.tappedSearchButton(searchType: .number)
                        } label: {
                            Label("Search by zipcode", systemImage: "location.magnifyingglass")
                        }
                        Button {
                            viewModel.tappedSearchButton(searchType: .string)
                        } label: {
                            Label("Search by city", systemImage: "location.viewfinder")
                        }
                        Section {
                            Button{
                                viewModel.tappedFarenheitCelciousButton(changedTo: .celsius)
                            } label: {
                                Label {
                                    Text("Celsius (°C)")
                                } icon: {
                                    if viewModel.unitTemperature == .celsius {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                            Button {
                                viewModel.tappedFarenheitCelciousButton(changedTo: .fahrenheit)
                            } label: {
                                Label {
                                    Text("Fahrenheit (°F)")
                                } icon: {
                                    if viewModel.unitTemperature == .fahrenheit {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
        }
        .alert("Error", isPresented: $viewModel.displayError, presenting: viewModel.error) { error in
            switch error {
            case .noValidZipcode:
                Button("Search", action: {viewModel.tappedSearchButton(searchType: .number)})
                Button("cancel", action: cancelAction)
            case .cityNotFound:
                Button("Search", action: {viewModel.tappedSearchButton(searchType: .string)})
                Button("cancel", action: cancelAction)
            case .timeout:
                Button("Try Again", action: {viewModel.tappedSearchButton(searchType: .number)})
                Button("Cacel", action: cancelAction)
            case .failedToDecode(_):
                Button("Ok", action: cancelAction)
            case .locationServiceOff:
                Button("Ok", action: cancelAction)
            }
        } message: { error in
            Text(error.message)
        }
        .sheet(isPresented: $viewModel.displaySearchView, onDismiss: {
            viewModel.displaySearchView = false
        }) {
            SearchViewControllerRepresentable(completionHandler: viewModel.completionHanlder, searchType: viewModel.searchType)
        }
        .onAppear {
            Task {
                /// we either fetch the last request that was saved or fetch weather based on location
                await viewModel.initialize()
            }
        }
    }

    private func cancelAction() {
        viewModel.displayError.toggle()
    }
}
