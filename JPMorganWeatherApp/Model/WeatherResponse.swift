//
//  WeatherResponse.swift
//  JPMorganWeatherApp
//
//  Created by Xavier Carty on 9/27/24.
//

import Foundation

struct WeatherResponse: Codable {
    let coord: Coordinates
    let weather: [Weather]
    let base : String
    let main: Conditions
    let visibility: Int
    let wind: Wind?
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
}

struct Coordinates: Codable {
    let lon: Double?
    let lat: Double?
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Conditions: Codable {
    let temp: Double
    let feelsLike: Double
    let minTemp: Double
    let maxTemp: Double
    let pressure: Double
    let humidity: Double
    let seaLevel: Double
    let grndLevel: Double

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case minTemp = "temp_min"
        case maxTemp = "temp_max"
        case pressure
        case humidity
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}
struct Wind: Codable {
    let speed: Double
    let deg: Double
    let gust: Double?
}

struct Clouds: Codable {
    let all: Int
}

struct Sys: Codable {
    let type: Int?
    let id: Int
    let country: String
    let sunrise: Int
    let sunset: Int
}
