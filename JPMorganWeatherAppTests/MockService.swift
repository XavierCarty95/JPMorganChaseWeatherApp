//
//  MockService.swift
//  JPMorganWeatherAppTests
//
//  Created by Xavier Carty on 9/27/24.
//

import Foundation

@testable import JPMorganWeatherApp

class MockService: Servicing {
    func searchByCoordinates(lat: Double, lon: Double) async throws -> JPMorganWeatherApp.WeatherResponse {
        if let jsonData = jsonString.data(using: .utf8) {
            do {
                let weather = try JSONDecoder().decode(WeatherResponse.self, from: jsonData)
                return weather
            } catch {
                print("Failed to decode JSON: \(error)")
                throw APIError.decodingError
            }
        } else {
            throw APIError.decodingError
        }
    }
    
    func fetchWeather(by city: String) async throws -> JPMorganWeatherApp.WeatherResponse {
        if let jsonData = jsonString.data(using: .utf8) {
            do {
                let weather = try JSONDecoder().decode(WeatherResponse.self, from: jsonData)
                return weather
            } catch {
                print("Failed to decode JSON: \(error)")
                throw APIError.decodingError
            }
        } else {
            throw APIError.decodingError
        }
    }
}

let jsonString = """
{
  "coord": {
    "lon": -87.65,
    "lat": 41.85
  },
  "weather": [
    {
      "id": 803,
      "main": "Clouds",
      "description": "broken clouds",
      "icon": "04d"
    }
  ],
  "base": "stations",
  "main": {
    "temp": 294.81,
    "feels_like": 294.65,
    "temp_min": 294.27,
    "temp_max": 295.42,
    "pressure": 1007,
    "humidity": 62,
    "sea_level": 1007,
    "grnd_level": 986
  },
  "visibility": 10000,
  "wind": {
    "speed": 11.32,
    "deg": 30,
    "gust": 18.01
  },
  "clouds": {
    "all": 75
  },
  "dt": 1727474174,
  "sys": {
    "type": 2,
    "id": 2010190,
    "country": "US",
    "sunrise": 1727437421,
    "sunset": 1727480342
  },
  "timezone": -18000,
  "id": 4887398,
  "name": "Chicago",
  "cod": 200
}
"""
