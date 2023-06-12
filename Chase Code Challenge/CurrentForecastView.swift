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
                    .bold()
                Text("High: \(viewModel.weatherModel?.highTemp ?? "")   Low: \(viewModel.weatherModel?.lowTemp ?? "")")
                VStack {
                    Image(viewModel.weatherModel?.imageName ?? "")
                        .resizable()
                        .frame(width: 80, height: 80)
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

                    } label: {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                }
            }
        }
        .alert("Error", isPresented: $viewModel.displayError, actions: {
            /// Could be expanded by setting three different errors one for handling zipcode, city not found, and possibly network issue
            Button("Ok") {
                viewModel.displayError = false
            }
        }, message: {
            Text("Sorry we couldn't find the city or zipcode request")
        })
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
}
