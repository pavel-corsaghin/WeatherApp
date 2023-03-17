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

