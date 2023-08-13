//
// Date+Extension.swift
// 
// Created by Alwin Amoros on 8/4/23.
// 

import Foundation

extension Date {
    private var dayDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter
    }
    var currentDay: String {
        dayDateFormatter.string(from: self)
    }
}
