//
//  DayView.swift
//  WeatherApp
//
//  Created by HungNguyen on 2023/03/17.
//

import SwiftUI

struct DayView: View {
    @StateObject var viewModel: DayViewModel
    
    var body: some View {
        VStack {
            if !viewModel.loading {
                ScrollView {
                    VStack {
                        Spacer(minLength: 110)
                        DayHeaderView(dayWeather: viewModel.dayWeather)
                        
                        Spacer(minLength: 50)
                        DayHourlyChartView(hourWeathers: viewModel.chartHourWeathers)
                        
                        DayHourlyForecastView(hourWeathers: viewModel.hourWeathers)
                        Spacer(minLength: 30)
                    }
                }
            } else {
                Spacer()
                ProgressView()
                    .progressViewStyle(.circular)
                    .frame(width: 40)
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
        .background{
            Image("background")
                .resizable()
                .scaledToFill()
        }
        .edgesIgnoringSafeArea(.all)
    }
}

