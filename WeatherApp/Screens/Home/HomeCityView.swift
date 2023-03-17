//
//  HomeCityView.swift
//  WeatherApp
//
//  Created by HungNguyen on 2023/03/17.
//

import SwiftUI
import WeatherKit

struct HomeCityView: View {
    @State var weather: Weather
    @State var cityName: String
    
    var body: some View {
        if let dailyForecast = weather.dailyForecast.first {
            VStack(spacing: 5) {
                Text(cityName)
                    .font(.title)
                Text("\(weather.currentWeather.temperature.value.rounded())°")
                    .font(.system(size: 80))
                Text(weather.currentWeather.condition.description)
                HStack {
                    Text("H: \(dailyForecast.highTemperature.value.rounded())°")
                    Text("L: \(dailyForecast.lowTemperature.value.rounded())°")
                }
            }
            .foregroundColor(.white)
        }
    }
}
