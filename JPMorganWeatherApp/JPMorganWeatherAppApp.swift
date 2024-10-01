//
//  JPMorganWeatherAppApp.swift
//  JPMorganWeatherApp
//
//  Created by Xavier Carty on 9/27/24.
//

import SwiftUI

@main
struct JPMorganWeatherAppApp: App {
    var body: some Scene {
        WindowGroup {
            WeatherView(viewModel: WeatherViewModel(), searchText: "")
        }
    }
}
