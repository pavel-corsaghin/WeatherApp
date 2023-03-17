//
//  DayHeaderView.swift
//  WeatherApp
//
//  Created by HungNguyen on 2023/03/17.
//

import SwiftUI
import WeatherKit

struct DayHeaderView: View {
    @State var dayWeather: DayWeather
    
    var body: some View {
        VStack(spacing: 5) {
            Text(dayWeather.date.weekDayFull)
                .font(.title)
            Text(dayWeather.date.formatted(with: "MMMM d, yyyy"))
            Spacer()
            Image(systemName: "\(dayWeather.symbolName).fill")
                .symbolRenderingMode(.multicolor)
                .font(.system(size: 100))
            HStack {
                Text("H: \(dayWeather.highTemperature.value.rounded())°")
                Text("L: \(dayWeather.lowTemperature.value.rounded())°")
            }
        }
        .foregroundColor(.white)
    }
}
