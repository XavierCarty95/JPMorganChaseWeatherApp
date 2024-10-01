//
//  JPMorganWeatherAppTests.swift
//  JPMorganWeatherAppTests
//
//  Created by Xavier Carty on 9/27/24.
//

import XCTest
@testable import JPMorganWeatherApp


final class JPMorganWeatherAppTests: XCTestCase {
    let service = MockService()
    var viewModel: WeatherViewModel!

    override func setUpWithError() throws {
        viewModel = WeatherViewModel(service: service)
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func testWeatherResponsePassDecodingWithNoError() async throws {
            let weatherResponse = try await service.fetchWeather(by: "Chicago")
             XCTAssertEqual(weatherResponse.name, "Chicago")
             XCTAssertEqual(weatherResponse.coord.lon, -87.65)
             XCTAssertEqual(weatherResponse.coord.lat, 41.85)
             XCTAssertEqual(weatherResponse.main.temp, 294.81)
             XCTAssertEqual(weatherResponse.main.feelsLike, 294.65)
             XCTAssertEqual(weatherResponse.main.minTemp, 294.27)
             XCTAssertEqual(weatherResponse.main.maxTemp, 295.42)
             XCTAssertEqual(weatherResponse.main.pressure, 1007)
             XCTAssertEqual(weatherResponse.main.humidity, 62)
             XCTAssertEqual(weatherResponse.weather.first?.description, "broken clouds")
             XCTAssertEqual(weatherResponse.sys.country, "US")
            XCTAssertEqual(weatherResponse.wind?.speed, 11.32)
            XCTAssertEqual(weatherResponse.wind?.deg, 30)
             XCTAssertEqual(weatherResponse.clouds.all, 75)
             XCTAssertEqual(weatherResponse.dt, 1727474174)
             XCTAssertEqual(weatherResponse.sys.sunrise, 1727437421)
             XCTAssertEqual(weatherResponse.sys.sunset, 1727480342)
             XCTAssertEqual(weatherResponse.cod, 200)
    }
}
