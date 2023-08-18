//
// MockWeatherServiceConsumer.swift
// 
// Created by Alwin Amoros on 8/15/23.
//

import Foundation

@testable import Basic_Weather_App

actor MockWeatherServiceConsumer: WeatherServiceConsumeable {

    func fetchCurrentWeatherWith<Model>(
        type: WeatherServiceSearch,
        _ numberOfDays: Days?)
    async -> Result<Model, WeatherServiceError> where Model : Response
    {
        try! await Task.sleep(nanoseconds: 1000000000)
        return .success(CurrentWeatherResponseModel.mockCurrentWeather as! Model)
    }

    func fetchCurrentWeatherWith<Model>(
        urlString: String)
    async -> Result<Model, WeatherServiceError> where Model : CurrentWeatherDataModeable
    {
        try! await Task.sleep(nanoseconds: 1000000000)
        return .success(CurrentWeatherResponseModel.mockCurrentWeather as! Model)
    }

    func fetchImageData(
        from iconName: String)
    async -> Data?
    {
        nil
    }
}
