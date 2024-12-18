//
//  MockData.swift
//  TicketSquare
//
//  Created by t2023-m0072 on 12/16/24.
//

import Foundation

struct MockData {
    static let ticketTimes: [Ticket.TicketcingTime] = {
        return [
            Ticket.TicketcingTime(hour: 1, minute: 50),
            Ticket.TicketcingTime(hour: 6, minute: 30),
            Ticket.TicketcingTime(hour: 10, minute: 10),
            Ticket.TicketcingTime(hour: 11, minute: 5),
            Ticket.TicketcingTime(hour: 11, minute: 20),
            Ticket.TicketcingTime(hour: 23, minute: 30)
        ]
    }()
}
