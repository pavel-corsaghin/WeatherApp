//
//  Double+Extension.swift
//  WeatherApp
//
//  Created by HungNguyen on 2023/03/16.
//

import Foundation

extension Double {
    func rounded() -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0 //maximum digits in Double after dot (maximum precision)
        return String(formatter.string(from: number) ?? "")
    }
}
