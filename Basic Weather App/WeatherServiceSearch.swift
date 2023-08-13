//
// WeatherSearchType.swift
// 
// Created by Alwin Amoros on 6/12/23.
// 

import CoreLocation
import Foundation

enum WeatherServiceSearch {
    case coordinates(CLLocationCoordinate2D)
    case cityName(String)
    case zipcode(String)
}

enum Days {
    case oneDay
    case fiveDays
    
    var count: Int {
        switch self {
        case .oneDay:
            return 8
        case .fiveDays:
            return 40
        }
    }
}
