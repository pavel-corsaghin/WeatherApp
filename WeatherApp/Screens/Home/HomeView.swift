//
//  HomeView.swift
//  WeatherApp
//
//  Created by HungNguyen on 2023/03/16.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack {
            if let weather = viewModel.weather {
                ScrollView {
                    VStack {
                        Spacer(minLength: 110)
                        HomeCityView(weather: weather, cityName: viewModel.cityName)
                        
                        Spacer(minLength: 50)
                        HourlyForecastView(next24HourWeathers: viewModel.next24HourWeathers)
                        
                        DailyForecastView(weather: weather)
                        Spacer(minLength: 30)
                    }
                }
            } else {
                VStack {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(.circular)
                        .frame(width: 40)
                    Spacer()
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
        .accentColor(.white)
        .onAppear {
            viewModel.requestLocationForWeather()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel())
    }
}
