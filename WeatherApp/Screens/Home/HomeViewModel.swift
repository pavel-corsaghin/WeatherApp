//
//  HomeViewModel.swift
//  WeatherApp
//
//  Created by HungNguyen on 2023/03/16.
//

import Foundation
import CoreLocation
import WeatherKit
import Combine

final class HomeViewModel: ObservableObject {
    
    @Published var weather: Weather?
    @Published var cityName: String = ""
    @Published var next24HourWeathers: [HourWeather] = []

    private let locationManager: LocationManagerProtocol
    private var cancellables = Set<AnyCancellable>()

    init(locationManager: LocationManagerProtocol = LocationManager()) {
        self.locationManager = locationManager

        setupBinding()
    }
    
    private func setupBinding() {
        locationManager.locationSubject
            .removeDuplicates()
            .sink(receiveValue: { [weak self] location in
                guard let self = self else {
                    return
                }
                
                self.getWeatherForLocation(location)
                self.getCityforLocation(location)
            })
            .store(in: &cancellables)
    }
    
    private func getWeatherForLocation(_ location: CLLocation) {
        Task.detached(priority: .userInitiated) {
            do {
                let weather = try await WeatherService.shared.weather(for: location)
                let next24HourWeathers = weather.hourlyForecast
                    .filter { $0.date >= Date() }
                    .prefix(24)
                DispatchQueue.main.async {
                    self.weather = weather
                    self.next24HourWeathers = Array(next24HourWeathers)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func getCityforLocation(_ location: CLLocation) {
        Task.detached(priority: .userInitiated) {
            do {
                let placemarks = try await CLGeocoder().reverseGeocodeLocation(location)
                DispatchQueue.main.async {
                    self.cityName = placemarks.first?.locality ?? "Unknown City"
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func requestLocationForWeather() {
        locationManager.requestLocationOnce()
    }
}
