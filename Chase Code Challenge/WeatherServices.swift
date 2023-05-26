//
//  WeatherServices.swift
//  Chase Code Challenge
//
//  Created by Alex on 5/25/23.
//

import Foundation
import NetworkComponents
import CoreLocation
//api key could be put more securely ie keychain
fileprivate let apiKey = "671285b71ed522d79582600da9fd685f"

enum WeatherURL {
    case coordinates(CLLocationCoordinate2D)
    case cityName(String)
    case zipcode(String)
    var url: URL {
        switch self {
        case .cityName(let cityName):
            return URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName),us&appid=\(apiKey)")!
        case .coordinates(let coordinate):
            return URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&appid=\(apiKey)")!
        case .zipcode(let zipcode):
            return URL(string: "https://api.openweathermap.org/data/2.5/weather?zip=\(zipcode)&appid=\(apiKey)")!
        }
    }
}

actor WeatherServices {
    
    func fetchWeatherWith(type: WeatherURL) async throws -> WeatherResponseModel? {
        let request = NetworkRequest(url: type.url, method: HttpMethod.get)
        request.responeType = WeatherResponseModel.self
        
        let urlConfiguration = URLSessionConfiguration.default
        let networkService = BaseNetworkServiceProvider(config: urlConfiguration)
        
        /// wait for 5 seconds for the response if no response returns nil
        async let responseToken = try await networkService.process(request, content: nil)
        guard try await responseToken.waitForCompletion(for: 5000),
              let response = try await responseToken.result as? NetworkResponse,
              let weatherResponseModel = response.content as? WeatherResponseModel else {
            return nil
        }
        return weatherResponseModel
    }

    /// This gets called when we have saved the latest successful request in which we can send a network request for forecast
    func fetchWeatherWith(urlString: String) async throws -> WeatherResponseModel? {
        guard let urlRequest = URL(string: urlString) else {
            //  unable to get url from string
            return nil
        }
        print(urlRequest)
        let request = NetworkRequest(url: urlRequest, method: HttpMethod.get)
        request.responeType = WeatherResponseModel.self
        
        /// pass the sessionconfiguration needed for our basenetworkserviceprovider
        let urlConfiguration = URLSessionConfiguration.default
        let networkService = BaseNetworkServiceProvider(config: urlConfiguration)

        /// wait for 5 seconds for the response if no response returns nil
        async let responseToken = try await networkService.process(request, content: nil)
        guard try await responseToken.waitForCompletion(for: 5000),
              let response = try await responseToken.result as? NetworkResponse,
              let weatherResponseModel = response.content as? WeatherResponseModel else {
            return nil
        }
        return weatherResponseModel
    }
}
