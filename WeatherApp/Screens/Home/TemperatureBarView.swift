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
    
    private let minValue: CGFloat
    private let maxValue: CGFloat
    private let gradient = LinearGradient(colors: [
        Color(.blue).opacity(0.3),
        Color(.yellow),
    ], startPoint: .leading, endPoint: .trailing)
    
    init(currentTemp: Double, minTemp: Double, maxTemp: Double) {
        self.currentTemp = currentTemp
        self.minTemp = minTemp
        self.maxTemp = maxTemp
        self.minValue = abs(minTemp) * 1.5
        self.maxValue = abs(maxTemp) * 1.5
    }
    
    private func countWidth(in geometry: GeometryProxy) -> CGFloat {
        return ((abs(minTemp) + abs(maxTemp)) / (abs(minValue) + abs(maxValue))) * geometry.size.width
    }
    
    private func countOffset(in geometry: GeometryProxy) -> CGFloat {
        return (abs(minValue) - abs(minTemp)) / (abs(minValue) + abs(maxValue)) * geometry.size.width
    }
    
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
                            .frame(width: countWidth(in: geometry))
                            .offset(x: countOffset(in: geometry))
                    }
                }
        }
    }
}

struct TemperatureBarView_Previews: PreviewProvider {
    static var previews: some View {
        TemperatureBarView(currentTemp: 5, minTemp: 5, maxTemp: 8)
            .frame(height: 20)
            .frame(width: 200)
    }
}
