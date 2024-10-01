import Foundation

protocol Servicing {
    func fetchWeather(by city: String) async throws -> WeatherResponse
    func searchByCoordinates(lat: Double, lon: Double)async throws -> WeatherResponse 
}

enum APIError: Error {
    case invalidURL
    case decodingError
}

class WeatherService: Servicing {
    func fetchWeather(by city: String) async throws -> WeatherResponse {
        guard let city = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), 
              let url = URL(string: "\(APIURL.url)?q=\(city)&appid=\(API.key)") else {
            throw APIError.invalidURL
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let weather = try JSONDecoder().decode(WeatherResponse.self, from: data)
            return weather
        } catch {
            print(error)
            throw APIError.decodingError
        }
    }

    func searchByCoordinates(lat: Double, lon: Double)async throws -> WeatherResponse  {
        guard let url  = URL(string: "\(APIURL.url)?lat=\(lat)&lon=\(lon)&appid=\(API.key)") else {
            throw APIError.invalidURL
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let weather = try JSONDecoder().decode(WeatherResponse.self, from: data)
            return weather
        } catch {
            print(error)
            throw APIError.decodingError
        }
    }
}
