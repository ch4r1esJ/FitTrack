//
//  Double + Extension.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/25/26.
//

import Foundation

extension Double {
    func formattedNumbersString() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: self)) ?? "0"
    }
}
