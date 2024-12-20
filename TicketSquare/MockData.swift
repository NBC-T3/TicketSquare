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
    
    static let tickets: [Ticket] = {
        var numberOfPeople = Ticket.NumberOfPeople()
        numberOfPeople.addAdult()
        numberOfPeople.addMinor()
        
        let movieDetail = MovieDetails(title: "제목",
                                       overview: "어쩌구",
                                       releaseDate: "312312412451",
                                       posterPath: "",
                                       runtime: 123,
                                       genres: [])
        
        let ticket = Ticket(movieDetails: movieDetail,
                            ticketingDate: .init(from: Date()),
                            ticketcingTime: Ticket.TicketcingTime(hour: 11, minute: 30),
                            numberOfPeople: numberOfPeople)
        
        return [ticket, ticket, ticket]
    }()
}
