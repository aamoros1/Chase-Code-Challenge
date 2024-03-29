//
//  WeatherResponseModel.swift
//  Chase Code Challenge
//
//  Created by Alex on 5/25/23.
//

import Foundation
protocol Response: Decodable {
    var cod: Int { get }
    var message: String? { get }
}

protocol WeatherDatable: Decodable {
    var dt: Int { get }
    var main: Main { get }
    var weathers: [Weather] { get }
    var clouds: Clouds { get }
    var wind: Wind { get }
    var visibility: Int { get }
    var sys: Sys { get }
}

protocol FiveDayWeatherModable: Decodable {
    var city: City { get }
    var cnt: Int { get }
    var list: [WeatherDatable] { get }
}

struct City: Decodable {
    var coord: Coord
    var country: String
    var id: Int
    var name: String
    var population: Int
    var sunrise: Int
    var sunset: Int
    var timezone: Int
}

struct FiveDayWeatherForeCastModel: FiveDayWeatherForeCastModelable {
    var city: City
    var cnt: Int
    var list: [WeatherDatable]
    var cod: Int
    var message: String?
    
    enum CodingKeys: CodingKey {
        case cod
        case message
        case city
        case cnt
        case list
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            self.cod = try container.decode(Int.self, forKey: .cod)
        } catch DecodingError.typeMismatch {
            let value = try container.decodeIfPresent(String.self, forKey: .cod)
            self.cod = try Int(value!, format: .number)
        }
        self.message = try?  container.decodeIfPresent(String.self, forKey: .message) ?? ""
        self.cnt = try container.decode(Int.self, forKey: .cnt)
        self.city = try container.decode(City.self, forKey: .city)
        self.list = try container.decode([CurrentWeatherResponseModel].self, forKey: .list)
    }
}

protocol FiveDayWeatherForeCastModelable: Response & FiveDayWeatherModable { }
protocol WeatherModelable: WeatherDatable {
    var dt: Int { get }
    var main: Main { get }
    var weathers: [Weather] { get }
    var clouds: Clouds { get }
    var wind: Wind { get }
    var visibility: Int { get }
    var sys: Sys { get }
    var coord: Coord? { get }
    var base: String? { get }
    var timezone: Int? { get }
    var id: Int? { get }
    var name: String { get }
}

protocol CurrentWeatherDataModeable: Response & WeatherModelable { }

struct CurrentWeatherResponseModel: CurrentWeatherDataModeable {
    let dt: Int
    let main: Main
    let weathers: [Weather]
    let clouds: Clouds
    let wind: Wind
    let visibility: Int
    let sys: Sys
    let coord: Coord?
    let base: String?
    let timezone: Int?
    let id: Int?
    let name: String
    let cod: Int
    var imageData: Data?
    var message: String?
    var weather: Weather {
        weathers.first ?? Weather.defaultValue
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.coord = try? container.decodeIfPresent(Coord.self, forKey: .coord) ?? .defaultValue
        self.weathers = try container.decodeIfPresent([Weather].self, forKey: .weathers) ?? []
        self.base = try? container.decodeIfPresent(String.self, forKey: .base) ?? ""
        self.main = try container.decodeIfPresent(Main.self, forKey: .main) ?? .defaultValue
        self.visibility = try container.decodeIfPresent(Int.self, forKey: .visibility) ?? 0
        self.wind = try container.decodeIfPresent(Wind.self, forKey: .wind) ?? .defaultValue
        self.clouds = try container.decodeIfPresent(Clouds.self, forKey: .clouds) ?? .defaultValue
        self.dt = try container.decodeIfPresent(Int.self, forKey: .dt) ?? 0
        self.sys = (try? container.decodeIfPresent(Sys.self, forKey: .sys)) ?? .defaultValue
        self.timezone = try? container.decodeIfPresent(Int.self, forKey: .timezone) ?? 0
        self.id = try? container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        self.name = (try? container.decodeIfPresent(String.self, forKey: .name)) ?? ""
        do {
            self.cod = try container.decodeIfPresent(Int.self, forKey: .cod) ?? 0
        } catch DecodingError.typeMismatch {
            let value = (try? container.decodeIfPresent(String.self, forKey: .cod)) ?? "0"
            
            self.cod = try Int(value, format: .number)
        }
        self.message = try container.decodeIfPresent(String.self, forKey: .message)
    }

    enum CodingKeys: String, CodingKey {
        case coord
        case weathers = "weather"
        case base, main, visibility, wind, clouds, dt
        case sys, timezone, id, name, cod, message
    }
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}

fileprivate extension Clouds {
    static var defaultValue: Self {
        .init(all: 0)
    }
}

// MARK: - Coord
struct Coord: Codable {
    let lon: Double
    let lat: Double
}

fileprivate extension Coord {
    static var defaultValue: Self {
        .init(lon: 0, lat: 0)
    }
}

// MARK: - Main
struct Main: Codable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let pressure : Int
    let humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }
}

fileprivate extension Main {
    static var defaultValue: Self {
        .init(
            temp: 0,
            feelsLike: 0,
            tempMin: 0,
            tempMax: 0,
            pressure: 0,
            humidity: 0
        )
    }
}

// MARK: - Sys
struct Sys: Codable {
    let type, id: Int
    let country: String
    let sunrise: Int
    let sunset: Int
}

fileprivate extension Sys {
    static var defaultValue: Self {
        .init(
            type: 0,
            id: 0,
            country: "",
            sunrise: 0,
            sunset: 0
        )
    }
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

fileprivate extension Weather {
    static var defaultValue: Self {
        .init(
            id: 0,
            main: "",
            description: "",
            icon: ""
        )
    }
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
    let deg: Int
}

fileprivate extension Wind {
    static var defaultValue: Self {
        .init(speed: 0, deg: 0)
    }
}
