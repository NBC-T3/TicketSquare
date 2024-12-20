//
//  UserInfo.swift
//  TicketSquare
//
//  Created by t2023-m0072 on 12/20/24.
//

import Foundation

struct UserInfo: Codable {
    
    let profileImage: Data?
    let id: String
    let password: String
    let name: String
    let birth: String
    let phoneNumber: String
    
    static func readDefault() -> UserInfo? {
        guard let id = UserDefaults.standard.string(forKey: UserInfo.Key.id),
              let password = UserDefaults.standard.string(forKey: UserInfo.Key.password),
              let name = UserDefaults.standard.string(forKey: UserInfo.Key.name),
              let birth = UserDefaults.standard.string(forKey: UserInfo.Key.birth),
              let phoneNumber = UserDefaults.standard.string(forKey: UserInfo.Key.phoneNumber) else { return nil }
        
        let profileImage = UserDefaults.standard.value(forKey: UserInfo.Key.profileIamge) as? Data

        return UserInfo(profileImage: profileImage,
                        id: id,
                        password: password,
                        name: name,
                        birth: birth,
                        phoneNumber: phoneNumber)
    }
    
    enum Key {
        static let profileIamge = "ProfileImage"
        static let id = "ID"
        static let password = "PW"
        static let name = "Name"
        static let phoneNumber = "PhoneNumber"
        static let birth = "Birth"
    }
}
