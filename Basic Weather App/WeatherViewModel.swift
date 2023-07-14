//
//  WeatherViewModel.swift
//  Chase Code Challenge
//
//  Created by Alex on 5/25/23.
//

import SwiftUI
import Foundation

typealias SearchType = SearchViewController.SearchType

enum WeatherServiceError: Error {
    case timeout
    case noValidZipcode
    case cityNotFound(String)
    case failedToDecode(Error?)
    case locationServiceOff

    var message: String {
        switch self {
        case .timeout:
            return "Session timed out"
        case .cityNotFound(let errorMessage):
            return "Error: \(errorMessage)"
        case .noValidZipcode:
            return "no valid zipcode"
        case .failedToDecode(let error):
            return "error: \(error?.localizedDescription ?? "")"
        case .locationServiceOff:
            return "Please enable share location back on"
        }
    }
}

final class WeatherViewModel: ObservableObject {
    @Published var weatherModel: WeatherModel?
    @Published var error: WeatherServiceError? = nil
    private var response: WeatherResponseModel!
    private let weatherServices: WeatherServiceConsumeable
    @Published var displayError = false
    @Published var displaySearchView = false
    var unitTemperature: UnitTemperature = .fahrenheit
    var searchType: SearchType = .number
    
    init(services: WeatherServiceConsumeable = WeatherServicesConsumer()) {
        weatherServices = services
    }
    
    func fetchCurrentLocation() async {
        ///  Move Task to background to avoid priority inversion
        Task(priority: .background) {
            /// Could be better to handle logic to ask for permission if we cant get current location
            guard let currentLocation = LocationServices.shared.currentLocation else {
                /// TODO: handle location permisions errors
                await setDisplayErrorFlag(with: .locationServiceOff)
                return
            }
            let type: WeatherSearchType = .coordinates(currentLocation.coordinate)
            
            let result: Result<WeatherResponseModel, WeatherServiceError> = try! await weatherServices.fetchWeatherWith(type: type)
            switch result {
            case .success(var responseModel):
                responseModel.imageData = await weatherServices.fetchImageData(from: responseModel.weather.icon)
                /// Save our successful request to know what request was last done
                UserDefaults.standard.set(type.url.description, forKey: "lastRequest")
                await update(with: responseModel)
            case .failure(let error):
                await setDisplayErrorFlag(with: error)
            }
        }
    }

    func initialize() async {
        ///  Move Task to background to avoid priority inversion
        Task(priority: .background) {
            /// Fetch last request we did if not fetch the weather for current location
            if let lastLocationUrl = UserDefaults.standard.string(forKey: "lastRequest") {
                let result: Result<WeatherResponseModel, WeatherServiceError> = try! await weatherServices.fetchWeatherWith(urlString: lastLocationUrl)
                switch result {
                case .success(var responseModel):
                    responseModel.imageData = await weatherServices.fetchImageData(from: responseModel.weather.icon)
                    await update(with: responseModel)
                case .failure(let error):
                    await setDisplayErrorFlag(with: error)
                }
                
            } else {
                await fetchCurrentLocation()
            }
        }
    }

    @MainActor
    private func update(with: WeatherResponseModel) {
        response = with
        weatherModel = WeatherModel(weatherResponseModel: with, unitTemperature: unitTemperature)
    }

    @MainActor
    func tappedFarenheitCelciousButton(changedTo: UnitTemperature) -> Void {
        unitTemperature = changedTo
        update(with: response)
    }

    /// display search screen and set the given searchType either numbers or alphabetical
    /// This will be used to set the keyboard type to either have numbers or qwerty board
    func tappedSearchButton(searchType: SearchType) {
        self.searchType = searchType
        displaySearchView = true
    }

    @MainActor
    private func setDisplayErrorFlag(with error: WeatherServiceError) {
        displayError = true
        self.error = error
    }

    func completionHanlder(inputText: String, searchType: SearchType) {
        ///  Move Task to background to avoid priority inversion
        Task(priority: .background) {
            /// Handle any special characters so we can properly create a url
            let allowedCharacters = CharacterSet(charactersIn: "aAbBcCdDeEfFgGhHiIjJkKlLmMnNoOpPqQrRsStTuUvVwWxXyYzZ0123456789")
            let fixedString = inputText.addingPercentEncoding(withAllowedCharacters: allowedCharacters) ?? inputText
            let weatherServiceType: WeatherSearchType = searchType == .number ? .zipcode(fixedString) : .cityName(fixedString)
            
            let result: Result<WeatherResponseModel, WeatherServiceError> = try! await weatherServices.fetchWeatherWith(type: weatherServiceType)
            
            switch result {
            case .success(var responseModel):
                responseModel.imageData = await weatherServices.fetchImageData(from: responseModel.weather.icon)
                await update(with: responseModel)
            case .failure(let error):
                await setDisplayErrorFlag(with: error)
            }
        }
    }
}

extension UnitTemperature: @unchecked Sendable { }
