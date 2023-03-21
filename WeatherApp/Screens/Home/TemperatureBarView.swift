//
//  TemperatureBarView.swift
//  WeatherApp
//
//  Created by HungNguyen on 2023/03/16.
//

import SwiftUI

struct TemperatureBarView: View {
    @State var currentTemp: Double
    @State var minTemp: Double
    @State var maxTemp: Double
    @State var weatherMinTemp: Double?
    @State var weatherMaxTemp: Double?
    @State var isToday: Bool

    private let gradient = LinearGradient(colors: [
        Color(.blue).opacity(0.3),
        Color(.yellow),
    ], startPoint: .leading, endPoint: .trailing)
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 35)
                .fill(Color.gray.opacity(0.5))
            
            RoundedRectangle(cornerRadius: 35)
                .fill(gradient)
                .mask {
                    GeometryReader { geometry in
                        RoundedRectangle(cornerRadius: 35)
                            .padding(1)
                            .shadow(radius: 10)
                            .frame(width: calculateTempWidth(in: geometry))
                            .offset(x: calculateOffset(in: geometry))
                    }
                }
            
            if isToday{
                GeometryReader { geometry in
                    Circle()
                        .fill(.white)
                        .padding(2)
                        .shadow(radius: 1)
                        .offset(x:  calculateDotOffset(in: geometry))
                }
            }
        }
    }
}

// MARK: - Views properties calculation

extension TemperatureBarView {
    private func calculateTempWidth(in geometry: GeometryProxy) -> CGFloat {
        let weatherRangeWidth = (weatherMaxTemp ?? maxTemp) - (weatherMinTemp ?? minTemp)
        let tempRangeWidth = maxTemp - minTemp
        let geometryWidth = geometry.size.width
        if weatherRangeWidth == 0 {
            return 0
        }
        return tempRangeWidth / weatherRangeWidth * geometryWidth
    }
    
    private func calculateOffset(in geometry: GeometryProxy) -> CGFloat {
        let weatherRangeWidth = (weatherMaxTemp ?? maxTemp) - (weatherMinTemp ?? minTemp)
        let geometryWidth = geometry.size.width
        let minTempOffset = minTemp - (weatherMinTemp ?? minTemp)
        
        if weatherRangeWidth == 0 {
            return 0
        }
        
        return minTempOffset / weatherRangeWidth * geometryWidth
    }
    
    private func calculateDotOffset(in geometry: GeometryProxy) -> CGFloat {
        let weatherRangeWidth = (weatherMaxTemp ?? maxTemp) - (weatherMinTemp ?? minTemp)
        let geometryWidth = geometry.size.width
        let currentTempOffset = currentTemp - (weatherMinTemp ?? minTemp)
        
        if weatherRangeWidth == 0 {
            return 0
        }
        
        return currentTempOffset / weatherRangeWidth * geometryWidth
    }
}


struct TemperatureBarView_Previews: PreviewProvider {
    static var previews: some View {
        TemperatureBarView(currentTemp: 5,
                           minTemp: 5,
                           maxTemp: 8,
                           weatherMinTemp: 0,
                           weatherMaxTemp: 10,
                           isToday: true)
            .frame(height: 20)
            .frame(width: 200)
    }
}
