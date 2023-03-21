//
//  DayViewModel.swift
//  WeatherApp
//
//  Created by HungNguyen on 2023/03/17.
//

import Foundation
import Combine
import WeatherKit

final class DayViewModel: ObservableObject {
    
    private let weather: Weather
    @Published var dayWeather: DayWeather
    @Published var hourWeathers: [HourWeather] = []
    @Published var chartHourWeathers: [HourWeather] = []
    @Published var loading: Bool = false

    init(weather: Weather, dayWeather: DayWeather) {
        self.weather = weather
        self.dayWeather = dayWeather
        
        generateHourWeathers()
    }
    
    private func generateHourWeathers() {
        loading = true
        Task.detached(priority: .userInitiated) {
            let startOfDay = self.dayWeather.date.startOfDay
            let endOfDay = self.dayWeather.date.endOfDay
            let hourWeathers = Array(self.weather.hourlyForecast
                .filter { $0.date >= startOfDay && $0.date < endOfDay })
            let chartHourWeathers = hourWeathers.filter { $0.date.hour % 4 == 0 }
            
            DispatchQueue.main.async {
                self.hourWeathers = hourWeathers
                self.chartHourWeathers = chartHourWeathers
                self.loading = false
            }
        }
    }
}
