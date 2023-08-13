//
//  WeatherServices.swift
//  Chase Code Challenge
//
//  Created by Alex on 5/25/23.
//

import Foundation
import NetworkComponents

protocol WeatherServiceConsumeable: Actor {
    func fetchCurrentWeatherWith<Model: Response>(
        type: WeatherServiceSearch,
        _ numberOfDays: Days?)
    async -> Result<Model, WeatherServiceError>

    func fetchCurrentWeatherWith<Model: CurrentWeatherDataModeable>(
        urlString: String)
    async -> Result<Model, WeatherServiceError>

    func fetchImageData(
        from iconName: String)
    async -> Data?
    var imageCacheManager: ImageCacheManager { get }
}

extension WeatherServiceConsumeable {
    var imageCacheManager: ImageCacheManager {
        ImageCacheManager.shared
    }
}

actor WeatherServicesConsumer: WeatherServiceConsumeable {
    private var networkService: BaseNetworkServiceProvider
    private let interceptor = NetworkServiceIntercept()

    init() {
        networkService = BaseNetworkServiceProvider(config: .default)
        networkService.interceptor = interceptor
    }
    
    func fetchCurrentWeatherWith<Model: Response>(
        type: WeatherServiceSearch,
        _ numberOfDays: Days? = nil)
    async -> Result<Model, WeatherServiceError>
    {
        let request = NetworkRequest(url: EnvironmentService.baseWeatherURL, method: HttpMethod.get)
        request.queryParams = [:]
        switch type {
        case .cityName(let city):
            request.queryParams?["q"] = city
        case .coordinates(let coordinates):
            request.queryParams?["lon"] = coordinates.longitude.description
            request.queryParams?["lat"] = coordinates.latitude.description
        case .zipcode(let zipcode):
            request.queryParams?["zip"] = zipcode
        }

        if let numberOfDays = numberOfDays {
            request.queryParams?["cnt"] = numberOfDays.count.description
        }
        request.responeType = Model.self
        
        /// wait for 5 seconds for the response if no response returns nil
        async let responseToken = await networkService.process(request, content: nil)
        guard
            await responseToken.waitForCompletion(for: 5000),
              let response = await responseToken.result as? NetworkResponse
        else {
            return .failure(.timeout)
        }
        guard
            let weatherResponseModel = response.content as? Model
        else {
            return .failure(.failedToDecode(response.error))
        }
        if let errorMessage = weatherResponseModel.message {
            return .failure(.cityNotFound(errorMessage))
        }
        return .success(weatherResponseModel)
    }

    /// This gets called when we have saved the latest successful request in which we can send a network request for forecast
    func fetchCurrentWeatherWith<Model: CurrentWeatherDataModeable>(
        urlString: String)
    async -> Result<Model, WeatherServiceError>
    {
        guard
            let urlRequest = URL(string: urlString)
        else {
            //  unable to get url from string
            fatalError("error handling saved string in UserDefaults")
        }
        let request = NetworkRequest(url: urlRequest, method: HttpMethod.get)
        request.queryParams = [:]
        request.responeType = Model.self

        /// wait for 5 seconds for the response if no response returns nil
        async let responseToken = await networkService.process(request, content: nil)
        guard
            await responseToken.waitForCompletion(for: 5000),
              let response = await responseToken.result as? NetworkResponse
        else {
            return .failure(.timeout)
        }
        guard
            let weatherResponseModel = response.content as? Model
        else {
            return .failure(.failedToDecode(response.error))
        }
        if let errorMessage = weatherResponseModel.message {
            return .failure(.cityNotFound(errorMessage))
        }
        UserDefaults.standard.set(response.url, forKey: "lastRequest")
        return .success(weatherResponseModel)
    }

    func fetchImageData(from iconName: String) async -> Data? {
        let url = URL(string: "https://openweathermap.org/img/wn/\(iconName)@2x.png")!

        /// Check if we have the image cached
        if let imageCache = imageCacheManager.cache.object(forKey: url.absoluteString as NSString) {
            return imageCache.imageData
        }
        let result: (data: Data, response: URLResponse)? = try? await URLSession.shared.data(from: url)
        guard
            let data = result?.data
        else {
            return nil
        }

        /// Cache image for future calls
        let imageCache = ImageCache(data: data)
        imageCacheManager.cache.setObject(imageCache, forKey: url.absoluteString as NSString)
        return result?.data
    }
}
