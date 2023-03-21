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
    
    // MARK: - Public properties
    
    @Published var weather: Weather?
    @Published var cityName: String = ""
    @Published var weatherMinTemp: Double?
    @Published var weatherMaxTemp: Double?
    @Published var next24HourWeathers: [HourWeather] = []

    // MARK: Private properties
    
    private let locationManager: LocationManagerProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Initializer

    init(locationManager: LocationManagerProtocol = LocationManager()) {
        self.locationManager = locationManager

        setupBinding()
    }
    
    // MARK: - Setup
    
    private func setupBinding() {
        locationManager.locationPublisher
            .removeDuplicates()
            .sink { [weak self] location in
                guard let self = self else {
                    return
                }
                
                self.getWeatherForLocation(location)
                self.getCityforLocation(location)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Actions
    
    private func getWeatherForLocation(_ location: CLLocation) {
        Task.detached(priority: .userInitiated) {
            do {
                let weather = try await WeatherService.shared.weather(for: location)
                let next24HourWeathers = Array(weather.hourlyForecast
                    .filter { $0.date >= Date() }
                    .prefix(24))
                let maxTemp = weather.dailyForecast
                    .map { $0.highTemperature.value }
                    .max()
                let minTemp = weather.dailyForecast
                    .map { $0.lowTemperature.value }
                    .min()
                DispatchQueue.main.async {
                    self.weather = weather
                    self.next24HourWeathers = next24HourWeathers
                    self.weatherMaxTemp = maxTemp
                    self.weatherMinTemp = minTemp
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
