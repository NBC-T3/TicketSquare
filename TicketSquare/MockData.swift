//
//  MockData.swift
//  TicketSquare
//
//  Created by t2023-m0072 on 12/16/24.
//

import Foundation

struct MockData {
    
    static let timeDatas: [Ticket.TicketingDate: Set<Ticket.TicketcingTime>] = {
       var timeDatas = [Ticket.TicketingDate: Set<Ticket.TicketcingTime>]()

        let countRange = 7...15
        let hourRange = 8...23
        let minuteRange = 0...59

        let date = Calendar.current.component(.day, from: Date())
        
        (0...6).forEach {
            let date = Ticket.TicketingDate(year: 2024,
                                            month: 12,
                                            day: date + $0)
            
            var times = Set<Ticket.TicketcingTime>()
            let randomCount = Int.random(in: countRange)
            
            while times.count < randomCount {
                times.insert(Ticket.TicketcingTime(hour: Int.random(in: hourRange),
                                                   minute: Int.random(in: minuteRange)))
            }
            
            timeDatas[date] = times
        }
        
        return timeDatas
    }()
    
//    static let ticketTimes: [Ticket.TicketcingTime] = {
//        return [
//            Ticket.TicketcingTime(hour: 1, minute: 50),
//            Ticket.TicketcingTime(hour: 6, minute: 30),
//            Ticket.TicketcingTime(hour: 10, minute: 10),
//            Ticket.TicketcingTime(hour: 11, minute: 5),
//            Ticket.TicketcingTime(hour: 11, minute: 20),
//            Ticket.TicketcingTime(hour: 1, minute: 50),
//            Ticket.TicketcingTime(hour: 6, minute: 30),
//            Ticket.TicketcingTime(hour: 10, minute: 10),
//            Ticket.TicketcingTime(hour: 11, minute: 5),
//            Ticket.TicketcingTime(hour: 11, minute: 20),
//            Ticket.TicketcingTime(hour: 23, minute: 30)
//        ]
//    }()
}
