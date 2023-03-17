//
//  DayHourlyForecastView.swift
//  WeatherApp
//
//  Created by HungNguyen on 2023/03/17.
//

import SwiftUI
import WeatherKit

struct DayHourlyForecastView: View {
    @State var hourWeathers: [HourWeather]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "clock")
                Text("24 - HOUR FORECAST")
            }
            .font(.caption)
            Divider()
            
            ForEach(hourWeathers, id: \.date) { hourForecast in
                HStack {
                    Text(hourForecast.date.formatted(with: "h a"))
                    Spacer()
                    Text("\(hourForecast.temperature.value.rounded())°")
                        .frame(width: 40)
                        .multilineTextAlignment(.trailing)
                    Spacer()
                    Image(systemName: "\(hourForecast.symbolName).fill")
                        .symbolRenderingMode(.multicolor)
                        .font(.system(size: 18))
                }
                .padding(.top, 5)
                Divider()
            }
        }
        .padding()
        .foregroundColor(.white)
        .background(Color.gray.opacity(0.6))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}
