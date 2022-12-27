//
//  Date+Extensions.swift
//  Machina
//
//  Created by Timotius Leonardo Lianoto on 27/12/22.
//

import Foundation

extension Date {
    func convertToStringFormat() -> String {
        let dateFormat = "dd-MM-yyyy"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let dateInString = dateFormatter.string(from: self)
        return dateInString
    }
    
    // MARK: - Static function
    static func convertStringToDate(string: String) -> Date {
        let dateFormat = "dd-MM-yyyy"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let date = dateFormatter.date(from: string)
        return date ?? Date()
    }
}
