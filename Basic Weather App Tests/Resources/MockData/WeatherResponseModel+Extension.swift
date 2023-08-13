//
// WeatherResponseModel+Extension.swift
// 
// Created by Alwin Amoros on 8/13/23.
// 

import Foundation
@testable import Basic_Weather_App

extension CurrentWeatherResponseModel {
    static var mockCurrentWeather: Self {
        let bundle = Bundle.testingBundle
        let path = bundle.path(forResource: "CurrentWeatherData", ofType: "json")
        let data = try! String(contentsOfFile: path!).data(using: .utf8)!
        return try! JSONDecoder.init().decode(Self.self, from: data)
    }
}
