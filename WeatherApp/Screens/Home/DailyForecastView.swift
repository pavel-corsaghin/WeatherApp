//
//  DailyForecastView.swift
//  WeatherApp
//
//  Created by HungNguyen on 2023/03/16.
//

import SwiftUI
import WeatherKit

struct DailyForecastView: View {
    @State var weather: Weather
    @State var viewModel: HomeViewModel
    @State private var selectedDayWeather: DayWeather?

    var body: some View {
        VStack {
            HStack {
                Image(systemName: "calendar")
                Text("10 - DAY FORECAST")
                    .font(.caption)
                Spacer()
            }
            Divider()
            
            ForEach(weather.dailyForecast, id: \.date) { dailyForecast in
                Button(action: {
                    selectedDayWeather = dailyForecast
                }, label: {
                    HStack {
                        Text(dailyForecast.date.weekDay)
                            .frame(width: 50, alignment: .leading)
                        Spacer()
                        
                        Image(systemName: "\(dailyForecast.symbolName).fill")
                            .symbolRenderingMode(.multicolor)
                        Spacer()
                        
                        Text("\(dailyForecast.lowTemperature.value.rounded())°")
                        TemperatureBarView(currentTemp: weather.currentWeather.temperature.value,
                                           minTemp: dailyForecast.lowTemperature.value,
                                           maxTemp: dailyForecast.highTemperature.value,
                                           weatherMinTemp: viewModel.weatherMinTemp,
                                           weatherMaxTemp: viewModel.weatherMaxTemp,
                                           isToday: dailyForecast.date.isInToday)
                            .frame(width: 100, height: 8)
                        Text("\(dailyForecast.highTemperature.value.rounded())°")
                    }
                    .padding(.top, 5)
                })
                Divider()
            }
            
        }
        .sheet(item: $selectedDayWeather, content: { dayWeather in
            DayView(viewModel: .init(weather: weather, dayWeather: dayWeather))
        })
        .frame(maxWidth: .infinity)
        .padding()
        .foregroundColor(.white)
        .background(Color.gray.opacity(0.6))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

extension DayWeather: Identifiable {
    public var id: Int {
        return Int(date.timeIntervalSince1970)
    }
}
