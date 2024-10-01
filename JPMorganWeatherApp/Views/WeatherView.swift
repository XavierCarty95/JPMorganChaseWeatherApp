//
//  ContentView.swift
//  JPMorganWeatherApp
//
//  Created by Xavier Carty on 9/27/24.
//

import SwiftUI

struct WeatherView: View {
    @ObservedObject var viewModel: WeatherViewModel
    @State var searchText: String = ""
    @State var isSearching: Bool = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    switch viewModel.viewState {
                    case .initial:
                        initial
                    case .loaded:
                        mainView
                    case .loading:
                        ProgressView()
                    case .error:
                        errorStateView
                    }
                }
            }.navigationTitle(Constants.title)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .searchable(text: $searchText, prompt: Constants.placeHolder)
                .onChange(of: searchText) { searchText in
                    if searchText.isEmpty {
                        isSearching = false
                    } else {
                        isSearching = true
                    }
                }.onSubmit(of: .search) {
                    Task {
                        viewModel.saveSearchToUserDefaults(searchText)
                        await getData()
                    }
                }.onAppear() {
                    viewModel.loadLastSearch()
                }
        }
    }

    private var initial: some View {
        InitialView()
    }

    @ViewBuilder private var image: some View {
        if let icon =  viewModel.weatherModel?.icon {
            AsyncImage(url: URL(string: "\(APIURL.imageURL)\(icon)@2x.png"), content: { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaledToFit()
                    .frame(width: 200, height: 100)
                    .shadow(color: .gray, radius: 10, x: 0, y: 10)
            }, placeholder: {
                ProgressView()
            })
        } else {
            Image(systemName: "thermometer")
                .resizable()
                .scaledToFit()
        }

    }

    @ViewBuilder private var mainView: some View {
        VStack {
            if !viewModel.lastSearch.isEmpty || viewModel.viewState == .loaded {
                contentView
                mapView
            } else {
                initial
            }
        }
    }

    private var mapView: some View {
        MapView(lat: viewModel.weatherModel?.lat ?? 37.7749,
                lon: viewModel.weatherModel?.long ?? -122.4194)
        .frame(height: UIScreen.main.bounds.height * 0.2)
        .frame(maxWidth: .infinity)
        .cornerRadius(12)
        .padding(.horizontal)
    }

    @ViewBuilder private var contentView: some View {
        VStack {
            image
            header
            HStack {
                temperature
                Spacer()
                weatherConditions
            }.padding(.horizontal)
            weatherSystem
                .padding(.bottom)
        }.frame(maxWidth: .infinity)
    }

    private var header: some View {
        VStack(spacing: 4) {
            Text("Location: " + (viewModel.location))
                .font(.title2)
            Text("Description: " + (viewModel.description))
                .font(.title3)
        }
    }

    @ViewBuilder private var temperature: some View {
        if let model = viewModel.weatherModel {
            VStack(spacing: 8) {
                Text("Temp: " + model.temp.asFahrenheitString)
                Text("Feels Like: " + model.feelsLike.asFahrenheitString)
                Text("Min Temp: " + model.minTemp.asFahrenheitString)
                Text("Max Temp: " +  model.maxTemp.asFahrenheitString)
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
    }

    @ViewBuilder private var weatherConditions: some View {
        if let model = viewModel.weatherConditions {
            VStack(spacing: 8) {
                Text("Cloud Percentage: " + model.cloudPercentage.toString)
                Text("Ground Level: " + model.groundLevel.toString)
                Text("Gust: " + model.gust.toString)
                Text("Degree: " + model.degree.toString)
                Text("Sea Level: " + model.seaLevel.toString)
                Text("Wind Speed: " + model.windSpeed.toString)
                Text("Pressure: " + model.pressure.toString)
                Text("Visibility: " + model.visibility.toString)
            }.font(.body)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
    }

    @ViewBuilder private var weatherSystem: some View {
        if let model = viewModel.weatherSystem {
            VStack(alignment: .leading, spacing: 8) {
                Text("Sunrise: " + model.sunrise)
                Text("Sunset: " + model.sunset)
                Text("Date: " + model.datetime)
            }.frame(maxWidth: .infinity, alignment: .center)
                .padding(.horizontal)
        }
    }

    private var errorStateView: some View {
        Text("Something went wrong make sure you type city correctly")
    }

    private func getData() async {
        await viewModel.fetchWeatherData(with: searchText)
    }
}

#Preview {
    WeatherView(viewModel: WeatherViewModel(), searchText: "")
}

struct Constants {
    static let title = "Weather"
    static let placeHolder = "Search City (New York)"
}
