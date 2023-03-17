//
//  HourlyForecastView.swift
//  WeatherApp
//
//  Created by HungNguyen on 2023/03/17.
//

import SwiftUI
import WeatherKit

struct HourlyForecastView: View {
    @State var next24HourWeathers: [HourWeather]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "clock")
                Text("HOURLY FORECAST")
            }
            .font(.caption)
            Divider()
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(next24HourWeathers, id: \.date) { hourForecast in
                        VStack(spacing: 15){
                            Text(hourForecast.date.formatted(with: "h"))
                            Image(systemName: "\(hourForecast.symbolName).fill")
                                .symbolRenderingMode(.multicolor)
                            Text("\(hourForecast.temperature.value.rounded())°")
                        }
                        .padding(.horizontal, 15)
                    }
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
