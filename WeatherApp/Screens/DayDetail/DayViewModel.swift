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
    
    init(weather: Weather, dayWeather: DayWeather) {
        self.weather = weather
        self.dayWeather = dayWeather
        
        generateHourWeathers()
    }
    
    private func generateHourWeathers() {
        let startOfDay = dayWeather.date.startOfDay
        let endOfDay = dayWeather.date.endOfDay
        hourWeathers = Array(weather.hourlyForecast
            .filter { $0.date >= startOfDay && $0.date < endOfDay })
        chartHourWeathers = hourWeathers.filter { $0.date.hour % 4 == 0 }
    }
}
