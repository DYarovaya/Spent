//
//  CustomDateFormatter.swift
//  Spent
//
//  Created by Дарья Яровая on 18.07.2021.
//

import Foundation

class CustomDateFormatter {
    
    func formatDay(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        
        return formatter.string(from: date)
    }
    
    func formatTime(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        
        return formatter.string(from: date)
    }
}
