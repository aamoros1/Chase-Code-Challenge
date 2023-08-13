//
// EnvironmentService.swift
// 
// Created by Alwin Amoros on 7/14/23.
// 

	

import Foundation

struct EnvironmentService {
    static var baseWeatherURL: URL = {
        URL(string: "https://api.openweathermap.org/data/2.5/weather")!
    }()

    static var baseForecastURL: URL = {
        URL(string: "https://api.openweathermap.org/data/2.5/forecast")!
    }()
}
