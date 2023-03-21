//
//  HomeViewModelTest.swift
//  WeatherAppTests
//
//  Created by HungNguyen on 2023/03/21.
//

import XCTest
import Combine
import CoreLocation
@testable import WeatherApp

final class HomeViewModelTest: XCTestCase {
    
    // MARK: - Mocks
    
    let mockLocation1: CLLocation = .init(latitude: 0, longitude: 0)
    let mockLocation2: CLLocation = .init(latitude: 1, longitude: 1)

    class LocationManagerMock: LocationManagerProtocol {
        private let locationSubject = PassthroughSubject<CLLocation, Never>()
        
        // Mock results
        var savedLocation: CLLocation?
        var newLocation: CLLocation?

        var locationPublisher: AnyPublisher<CLLocation, Never> {
            locationSubject.eraseToAnyPublisher()
        }
        
        func requestLocationOnce() {
            if let savedLocation = savedLocation {
                locationSubject.send(savedLocation)
            }
            
            guard let newLocation = newLocation else {
                return
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.locationSubject.send(newLocation)
                self.savedLocation = newLocation
            })
        }
    }
    
    // MARK: - Properties

    private var cancelables = Set<AnyCancellable>()
    
    // MARK: - Setups

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // MARK: - Test Cases

    func test_if_no_saved_location_then_no_locations_received_immediately() throws {
        // Given
        let locationManager = LocationManagerMock()
        let vm = HomeViewModel(locationManager: locationManager)
        var receivedLocation: CLLocation?
        locationManager.locationPublisher
            .sink { location in  receivedLocation = location }
            .store(in: &cancelables)
        
        // When
        vm.requestLocationForWeather()
        _ = XCTWaiter.wait(for: [expectation(description: "Wait for 0.1 seconds")], timeout: 0.1)
        
        // Then
        XCTAssertNil(receivedLocation)
    }
    
    func test_if_has_saved_location_then_location_received_immediately() throws {
        // Given
        let locationManager = LocationManagerMock()
        locationManager.savedLocation = mockLocation1
        let vm = HomeViewModel(locationManager: locationManager)
        var receivedLocation: CLLocation?
        locationManager.locationPublisher
            .sink { location in  receivedLocation = location }
            .store(in: &cancelables)
        
        // When
        vm.requestLocationForWeather()
        _ = XCTWaiter.wait(for: [expectation(description: "Wait for 0.1 seconds")], timeout: 0.1)
        
        // Then
        XCTAssertEqual(receivedLocation, mockLocation1)
    }
    
    func test_if_no_saved_location_and_has_new_location_then_location_received_after_timeout() throws {
        // Given
        let locationManager = LocationManagerMock()
        locationManager.newLocation = mockLocation1
        let vm = HomeViewModel(locationManager: locationManager)
        var receivedLocation: CLLocation?
        locationManager.locationPublisher
            .sink { location in  receivedLocation = location }
            .store(in: &cancelables)
        
        // When
        vm.requestLocationForWeather()
        _ = XCTWaiter.wait(for: [expectation(description: "Wait for 1 seconds")], timeout: 1)
        
        // Then
        XCTAssertEqual(receivedLocation, mockLocation1)
    }
    
    func test_if_has_saved_location_and_new_location_then_received_both_by_order() throws {
        // Given
        let locationManager = LocationManagerMock()
        locationManager.savedLocation = mockLocation1
        locationManager.newLocation = mockLocation2
        let vm = HomeViewModel(locationManager: locationManager)
        var receivedLocation: CLLocation?
        locationManager.locationPublisher
            .sink { location in  receivedLocation = location }
            .store(in: &cancelables)
        
        // When
        vm.requestLocationForWeather()
        _ = XCTWaiter.wait(for: [expectation(description: "Wait for 0.1 seconds")], timeout: 0.1)
        
        // Then
        XCTAssertEqual(receivedLocation, mockLocation1)
        
        // When
        _ = XCTWaiter.wait(for: [expectation(description: "Wait for 1 seconds")], timeout: 1)
        
        // Then
        XCTAssertEqual(receivedLocation, mockLocation2)
    }

    func test_if_has_saved_location_and_new_location_then_new_location_replaces_saved_location() throws {
        // Given
        let locationManager = LocationManagerMock()
        locationManager.newLocation = mockLocation1
        let vm = HomeViewModel(locationManager: locationManager)
        locationManager.locationPublisher
            .sink { _ in }
            .store(in: &cancelables)
        
        // When
        vm.requestLocationForWeather()
        _ = XCTWaiter.wait(for: [expectation(description: "Wait for 1 seconds")], timeout: 1)
        
        // Then
        XCTAssertEqual(locationManager.savedLocation, mockLocation1)
    }
}
