//
//  WeatherViewModel.swift
//  JPMorganWeatherApp
//
//  Created by Xavier Carty on 9/27/24.
//

import Foundation
import Combine
import CoreLocation

class WeatherViewModel: ObservableObject {
    let service: Servicing
    @Published var weatherResponse: WeatherResponse? = nil
    @Published var viewState: ViewState = .initial

    @Published var weatherModel: WeatherModel?
    @Published var weatherConditions: WeatherConditionsModel?
    @Published var weatherSystem: WeatherSystemsModel?

    @Published var location: String = ""
    @Published var description: String = ""
    @Published var locationManager = LocationManager()
    @Published var locationDenied: Bool = false

    @Published var lat: Double = 0.0
    @Published var lon: Double = 0.0
    @Published var lastSearch: String = ""

    private var cancellables = Set<AnyCancellable>()

    init(service: Servicing = WeatherService()) {
        self.service = service
    }

    @MainActor
    func requestUserLocation() async {
        viewState = .loading
        do {
            let location = try await locationManager.requestLocationAsync()
            self.lat = location.coordinate.latitude
            self.lon = location.coordinate.longitude
            await fetchWeatherDataByLocation()
            viewState = .loaded
        } catch {
            print("Failed to get location: \(error)")
            viewState = .error
        }
    }

    func saveSearchToUserDefaults(_ query: String) {
        UserDefaults.standard.set(query, forKey: "search")
    }

    func loadLastSearch() {
        viewState = .loading
        if let lastSearch = UserDefaults.standard.string(forKey: "search") {
            self.lastSearch = lastSearch
            Task {
                await fetchWeatherData(with: lastSearch)
            }
        } else {
            Task {
                await requestUserLocation()
            }
        }
    }

    @MainActor
    func handleAuthorizationStatus(_ status: CLAuthorizationStatus) {
        switch status {
        case .denied, .restricted:
            self.locationDenied = true
            self.viewState = .error // Update state in main thread
        case .authorizedWhenInUse, .authorizedAlways:
            self.locationManager.requestLocation()
        case .notDetermined:
            print("Requesting.")
        @unknown default:
            print("Unknown authorization status.")
        }
    }

    @MainActor
    func fetchWeatherData(with searchText: String) async {
        viewState = .loading
        do {
            self.weatherResponse = try await service.fetchWeather(by: searchText)
            setupWeather()
            setupWeatherConditions()
            setupWeatherSystem()
            viewState = .loaded
        } catch {
            print(error)
            viewState = .error
        }
    }

    @MainActor
    func fetchWeatherDataByLocation() async {
        do {
            self.weatherResponse = try await service.searchByCoordinates(lat: lat, lon: lon)
            setupWeather()
            setupWeatherConditions()
            setupWeatherSystem()
            viewState = .loaded
        } catch {
            print(error)
            viewState = .error
        }
    }

    func setupWeather() {
        self.location = weatherResponse?.name ?? "N/A"
        self.description = weatherResponse?.weather.first?.description ?? "N/A"

        self.weatherModel = weatherResponse.map({
            WeatherModel(weatherType: $0.weather.first?.main ?? "N/A",
                         temp: $0.main.temp.kelvinToFahrenheit,
                         minTemp: $0.main.minTemp.kelvinToFahrenheit,
                         maxTemp: $0.main.maxTemp.kelvinToFahrenheit,
                         feelsLike: $0.main.feelsLike.kelvinToFahrenheit,
                         humidity: $0.main.humidity,
                         lat: $0.coord.lat ?? 0.0,
                         long: $0.coord.lon ?? 0.0,
                         icon: $0.weather.first?.icon ?? "N/A")
        })
    }

    func setupWeatherConditions() {
        self.weatherConditions = weatherResponse.map({
            WeatherConditionsModel(pressure: $0.main.pressure,
                                   seaLevel: $0.main.seaLevel,
                                   groundLevel: $0.main.grndLevel,
                                   visibility: $0.visibility,
                                   windSpeed: $0.wind?.speed ?? 0.0,
                                   degree: $0.wind?.deg ?? 0.0,
                                   cloudPercentage: $0.clouds.all,
                                   gust: $0.wind?.gust ?? 0.0)
        })
    }

    func setupWeatherSystem() {
        self.weatherSystem = weatherResponse.map({
            WeatherSystemsModel(sunrise: $0.sys.sunrise.unixToDateString(timezoneOffset: $0.timezone),
                                sunset: $0.sys.sunset.unixToDateString(timezoneOffset: $0.timezone),
                                datetime: $0.dt.unixToDateString(timezoneOffset: $0.timezone))
        })
    }
}

// Enum to track the view state
enum ViewState {
    case initial
    case loaded
    case loading
    case error
}


struct WeatherModel {
    let weatherType: String
    let temp: Int
    let minTemp: Int
    let maxTemp: Int
    let feelsLike: Int
    let humidity: Double
    let lat: Double
    let long: Double
    let icon: String
}

struct WeatherConditionsModel {
    let pressure: Double
    let seaLevel: Double
    let groundLevel: Double
    let visibility: Int
    let windSpeed: Double
    let degree: Double
    let cloudPercentage: Int
    let gust: Double
}


struct WeatherSystemsModel {
    let sunrise: String
    let sunset: String
    let datetime: String
}
