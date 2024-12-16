//
//  Ticket.swift
//  TicketSquare
//
//  Created by t2023-m0072 on 12/16/24.
//

import Foundation

struct Ticket {
    
    // 예매 일자
    private(set) var date: Ticket.TicketingDate
    
    // 예매 시간
    private(set) var time: Ticket.TicketcingTime
    
    // 인원 수
    private(set) var numberOfPeople: Ticket.NumberOfPeople
    
    // 예매 일자 열거형
    struct TicketingDate {
        private let year: Int
        private let month: Int
        private let day: Int
        
        init(from date: Date) {
            self.year = Calendar.current.component(.year, from: date)
            self.month = Calendar.current.component(.month, from: date)
            self.day = Calendar.current.component(.day, from: date)
        }
    }
    
    // 예매 시간 열거형
    struct TicketcingTime {
        private let hour: Int
        private let minute: Int
        
        init(hour: Int, minute: Int) {
            self.hour = hour
            self.minute = minute
        }
    }

    // 인원 수 열거형
    struct NumberOfPeople {
        private var adult: Int
        private var minor: Int
        
        func ticketPrice(adult adultPrice: Int, minor minorPrice: Int) -> Int {
            return ( adultPrice * adult ) + ( minorPrice * minor )
        }
        
        mutating func addAdult() {
            self.adult += 1
        }
        
        mutating func subtractAdult() {
            self.adult -= 1
        }
        
        mutating func addMinor() {
            self.minor += 1
        }
        
        mutating func subtractMinor() {
            self.minor -= 1
        }
    }
    
    // 예매 일자 재설정
    mutating func updateDate(to date: Date) {
        self.date = TicketingDate(from: date)
    }
    
    // 예매 시간 재설정
    mutating func updateTime(to time: TicketcingTime) {
        self.time = time
    }
    
    // 인원 수정
    mutating func updatePeople(_ editNumberOfPeople: EditNumberOfPeople) {
        switch editNumberOfPeople {
        case .add(.adult):
            numberOfPeople.addAdult()
        case .subtract(.adult):
            numberOfPeople.subtractAdult()
        case .add(.minor):
            numberOfPeople.addMinor()
        case .subtract(.minor):
            numberOfPeople.subtractMinor()
        }
    }
        
    // 인원 수정 스타일
    enum EditNumberOfPeople {
        case add(PeopleType)
        case subtract(PeopleType)
        
        enum PeopleType {
            case adult
            case minor
        }
    }
    
}

