//
// WeatherSearchType.swift
// 
// Created by Alwin Amoros on 6/12/23.
// 

import CoreLocation
import Foundation

enum WeatherSearchType {
    case coordinates(CLLocationCoordinate2D)
    case cityName(String)
    case zipcode(String)
    var url: URL {
        switch self {
        case .cityName(let cityName):
            return URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName),us")!
        case .coordinates(let coordinate):
            return URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)")!
        case .zipcode(let zipcode):
            return URL(string: "https://api.openweathermap.org/data/2.5/weather?zip=\(zipcode)")!
        }
    }
}
