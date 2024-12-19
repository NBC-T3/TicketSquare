//
//  TicketManager.swift
//  TicketSquare
//
//  Created by t2023-m0072 on 12/19/24.
//

import Foundation

struct TicketManager {
    
    static let key = "Tickets"
    
    func read() -> [Ticket] {
        let nsDatas: [NSData] = UserDefaults.standard.value(forKey: Self.key) as? [NSData] ?? []
        
        let tickets = nsDatas.compactMap {
            Ticket(from: $0)
        }
        
        return tickets
    }
    
    func creat(_ ticket: Ticket) {
        var tickets = read()
        tickets.append(ticket)
        save(tickets)
    }
    
    func delete(_ ticket: Ticket) {
        var tickets = read()
        tickets = tickets.filter { $0 != ticket }
        save(tickets)
    }
        
    private func save(_ tickets: [Ticket]) {
        let nsDatas = tickets.compactMap {
            $0.nsData()
        }
        
        UserDefaults.standard.set(nsDatas, forKey: Self.key)
    }
}
