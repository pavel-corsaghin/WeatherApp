//
//  DayHourlyChartView.swift
//  WeatherApp
//
//  Created by HungNguyen on 2023/03/17.
//

import SwiftUI
import WeatherKit
import Charts

struct DayHourlyChartView: View {
    @State var hourWeathers: [HourWeather]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "chart.xyaxis.line")
                Text("DAY WEATHER CHART")
            }
            .font(.caption)
            
            Chart {
                ForEach(hourWeathers, id: \.date) { hourForecast in
                    LineMark(x: .value("Hour", hourForecast.date.formatted(with: "h a")),
                             y: .value("Temperature", hourForecast.temperature.converted(to: .fahrenheit).value))
                }
            }
        }
        .padding()
        .foregroundColor(.white)
        .background(Color.gray.opacity(0.6))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}
