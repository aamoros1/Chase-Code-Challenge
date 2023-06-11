//
//  WeatherViewModel.swift
//  Chase Code Challenge
//
//  Created by Alex on 5/25/23.
//

import SwiftUI
import Foundation

typealias SearchType = SearchViewController.SearchType


/// main functions used outside of the viewmodel could be extracted and set protocols in which could assist with using mock data or testing purposes
final class WeatherViewModel: ObservableObject {
    @Published var weatherModel: WeatherModel?
    private let weatherServices: WeatherServiceConsumeable
    @Published var displayError = false
    @Published var displaySearchView = false
    var searchType: SearchType = .number
    
    init(services: WeatherServiceConsumeable = WeatherServicesConsumer()) {
        weatherServices = services
    }
    
    @MainActor
    func fetchCurrentLocation() async {
        /// Could be better to handle logic to ask for permission if we cant get current location
        guard let currentLocation = LocationServices.shared.currentLocation else {
            print("something bad happen")
            displayError = true
            return
        }
        let type: WeatherSearchType = .coordinates(currentLocation.coordinate)
        
        guard let model: WeatherResponseModel = try? await weatherServices.fetchWeatherWith(type: type) else {
            setDisplayErrorFlag()
            return
        }
        /// Save our successful request to know what request was last done
        UserDefaults.standard.set(type.url.description, forKey: "lastRequest")
        weatherModel = WeatherModel(weatherResponseModel: model)
    }

    @MainActor
    func initialize() async {
        /// Fetch last request we did if not fetch the weather for current location
        if let lastLocationUrl = UserDefaults.standard.string(forKey: "lastRequest") {
            guard let model: WeatherResponseModel = try? await weatherServices.fetchWeatherWith(urlString: lastLocationUrl) else {
                setDisplayErrorFlag()
                return
            }
            
            weatherModel = WeatherModel(weatherResponseModel: model)
        } else {
            await fetchCurrentLocation()
        }
    }

    /// display search screen and set the given searchType either numbers or alphabetical
    /// This will be used to set the keyboard type to either have numbers or qwerty board
    func tappedSearchButton(searchType: SearchType) {
        self.searchType = searchType
        displaySearchView = true
    }

    @MainActor
    private func setDisplayErrorFlag() {
        displayError = true
    }

    func completionHanlder(inputText: String, searchType: SearchType) {
        Task {
            /// Handle any special characters so we can properly create a url
            let allowedCharacters = CharacterSet(charactersIn: "aAbBcCdDeEfFgGhHiIjJkKlLmMnNoOpPqQrRsStTuUvVwWxXyYzZ0123456789")
            let fixedString = inputText.addingPercentEncoding(withAllowedCharacters: allowedCharacters) ?? inputText
            let weatherServiceType: WeatherSearchType = searchType == .number ? .zipcode(fixedString) : .cityName(fixedString)
            
            guard let model: WeatherResponseModel = try? await weatherServices.fetchWeatherWith(type: weatherServiceType) else {
                /// we werent able to get a response and thus display error screen.
                await setDisplayErrorFlag()
                return
            }
            /// Save the last request done successful so we can pull it out later when the user comes back
            UserDefaults.standard.set(weatherServiceType.url.description, forKey: "lastRequest")
            DispatchQueue.main.async {
                self.weatherModel = WeatherModel(weatherResponseModel: model)
            }
            
        }
    }
}
