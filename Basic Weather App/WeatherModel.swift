//
//  WeatherModel.swift
//  Chase Code Challenge
//
//  Created by Alex on 5/25/23.
//

import Foundation

struct WeatherModel {
    private let weatherResponseModel: WeatherResponseModel
    private let unitTemperature: UnitTemperature
    
    init(weatherResponseModel: WeatherResponseModel, unitTemperature: UnitTemperature) {
        self.weatherResponseModel = weatherResponseModel
        self.unitTemperature = unitTemperature
    }
    
    var city: String {
        weatherResponseModel.name
    }

    var currentWeather: String {
        weatherResponseModel.weather.description
    }
    var sunrise: String {
        Date(timeIntervalSince1970: TimeInterval(weatherResponseModel.sys.sunrise))
            .formatted(date: .omitted, time: .standard)
            .description
    }
    
    var sunset: String {
        Date(timeIntervalSince1970: TimeInterval(weatherResponseModel.sys.sunset))
            .formatted(date: .omitted, time: .standard)
            .description
    }

    var feelsLike: String {
        /// since the values we have are in kelvin we could convert it to fahrenheit and give us the proper value
        measurementFormatter.string(from: Measurement(value: weatherResponseModel.main.feelsLike,
                                                      unit: UnitTemperature.kelvin)
            .converted(to: unitTemperature))
    }

    var currentTemp: String {
        measurementFormatter.string(from: Measurement(value: weatherResponseModel.main.temp,
                                                      unit: UnitTemperature.kelvin)
            .converted(to: unitTemperature))
    }
    
    var highTemp: String {
        measurementFormatter.string(from: Measurement(value: weatherResponseModel.main.tempMax,
                                                      unit: UnitTemperature.kelvin)
            .converted(to: unitTemperature))
    }
    
    var lowTemp: String {
        measurementFormatter.string(from: Measurement(value: weatherResponseModel.main.tempMin,
                                                      unit: UnitTemperature.kelvin)
            .converted(to: unitTemperature))
    }

    var imageData: Data? {
        weatherResponseModel.imageData
    }

    /// Formatter to handle decimal placement for given values
    private let measurementFormatter: MeasurementFormatter = {
        let measurementFormatter = MeasurementFormatter()
        measurementFormatter.unitStyle = .medium
        measurementFormatter.numberFormatter.maximumFractionDigits = 1
        measurementFormatter.unitOptions = .providedUnit
        return measurementFormatter
    }()
}
