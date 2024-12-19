//
//  Ticket.swift
//  TicketSquare
//
//  Created by t2023-m0072 on 12/16/24.
//

import Foundation

// MARK: - Ticket

/// 예매 페이지 티켓 데이터 형태
struct Ticket {
    
    // 예매 일자
    private(set) var ticketingDate: Ticket.TicketingDate = TicketingDate(from: Date.now)
    // 예매 시간
    private(set) var ticketcingTime: Ticket.TicketcingTime?
    // 인원 수
    private(set) var numberOfPeople = Ticket.NumberOfPeople()
    
    // 예매 일자 재설정
    mutating func updateDate(to date: Date) {
        self.ticketingDate = TicketingDate(from: date)
    }
    // 예매 시간 재설정
    mutating func updateTime(to time: TicketcingTime?) {
        self.ticketcingTime = time
    }
    // 인원 수정
    mutating func updatePeople(_ editNumberOfPeople: EditNumberOfPeople) {
        switch editNumberOfPeople {
        case .adult(.add):
            numberOfPeople.addAdult()
        case .adult(.subtract):
            numberOfPeople.subtractAdult()
        case .adult(.update(let numberOfAdult)):
            numberOfPeople.updateAdult(numberOfAdult)
            
        case .minor(.add):
            numberOfPeople.addMinor()
        case .minor(.subtract):
            numberOfPeople.subtractMinor()
        case .minor(.update(let numberOfMinor)):
            numberOfPeople.updateMinor(numberOfMinor)
        }
    }
    
}

// MARK: - struct TicketingDate

extension Ticket {
    // 예매 일자 구조체
    struct TicketingDate: Hashable {
        private let year: Int
        private let month: Int
        private let day: Int
        
        init(year: Int, month: Int, day: Int) {
            self.year = year
            self.month = month
            self.day = day
        }
        
        init(from date: Date) {
            self.year = Calendar.current.component(.year, from: date)
            self.month = Calendar.current.component(.month, from: date)
            self.day = Calendar.current.component(.day, from: date)
        }
    }

        
}

// MARK: - struct TicketcingTime

extension Ticket {
    // 예매 시간 구조체
    struct TicketcingTime: Hashable, Comparable {
        
        private let hour: Int
        private let minute: Int
        
        init(hour: Int, minute: Int) {
            let hour = hour < 24 ? hour : 0
            let minute = minute < 60 ? minute : 0

            self.hour = hour
            self.minute = minute
        }
        
        // 셀에서 보여질 문자열 형태
        func cellForm() -> String {
            return [hour, minute]
                .map { formatter($0) }
                .joined(separator: ":")
        }
        
        static func < (lhs: Ticket.TicketcingTime, rhs: Ticket.TicketcingTime) -> Bool {
            lhs.cellForm() < rhs.cellForm()
        }
        
        // 문자 형태화 메서드
        private func formatter(_ value: Int) -> String {
            guard (0...59).contains(value) else { return "00" }
            let valueStr = value < 10 ? "0\(value)" : "\(value)"
            return valueStr
        }
    }
    
}

// MARK: - struct NumberOfPeople

extension Ticket {
    // 인원 수 구조체
    struct NumberOfPeople {
        
        var totalPrice: Int {
            adult * 15000 + minor * 12000
        }
        
        // 성인 인원 수
        private var adult: Int = 0
        // 미성년자 인원 수
        private var minor: Int = 0
        
        var isSet: Bool {
            !(adult == 0 && minor == 0)
        }
    
        // 성인 +1
        mutating func addAdult() {
            self.adult += 1
        }
        // 성인 -1
        mutating func subtractAdult() {
            guard adult > 0 else { return }

            self.adult -= 1
        }
        // 성인 인원 수 업데이트
        mutating func updateAdult(_ numberOfAdults: Int) {
            guard numberOfAdults >= 0 else { return }
            self.adult = numberOfAdults
        }
        
        // 미성년자 +1
        mutating func addMinor() {
            self.minor += 1
        }
        // 미성년자 -1
        mutating func subtractMinor() {
            guard minor > 0 else { return }
            self.minor -= 1
        }
        // 미성년자 인원 수 업데이트
        mutating func updateMinor(_ numberOfMinors: Int) {
            guard numberOfMinors >= 0 else { return }
            self.minor = numberOfMinors
        }
        
    }
    
}

// MARK: - enum EditNumberOfPeople

extension Ticket {
    // 인원 수정 스타일
    enum EditNumberOfPeople {
        case adult(EditType)
        case minor(EditType)
        
        enum EditType {
            case update(Int)
            case add
            case subtract
        }
    }
    
}
