//
//  PriceFormatter.swift
//  TicketSquare
//
//  Created by t2023-m0072 on 12/18/24.
//

import Foundation

struct PriceFormatter {
    
    //가격 포멧
    //1000 단위 구분
    private static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        return formatter
    }()
    
    // Int를 원화 형식으로 변환
    static func won(_ number: Int) -> String {
        guard let result = formatter.string(from: NSNumber(value: number)) else { return "0 원"}
        return result + " 원"
    }
}

