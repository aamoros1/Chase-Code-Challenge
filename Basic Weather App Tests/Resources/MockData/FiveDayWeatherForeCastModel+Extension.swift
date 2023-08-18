//
// FiveDayWeatherForeCastModel+Extension.swift
// 
// Created by Alwin Amoros on 8/15/23.
// 

import Foundation

@testable import Basic_Weather_App

extension FiveDayWeatherForeCastModel {
    static var mockData: Self {
        let bundle = Bundle.testingBundle
        let path = bundle.path(forResource: "FiveDayWeatherForecast", ofType: "json")
        let data = try! String(contentsOfFile: path!).data(using: .utf8)!
        return try! JSONDecoder.init().decode(Self.self, from: data)
    }
}
