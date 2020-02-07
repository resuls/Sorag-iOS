//
//  Login.swift
//  Sorag
//
//  Created by Resul on 07.02.20.
//  Copyright © 2020 Resulkary Saparov. All rights reserved.
//

import Foundation

struct TokenUser: Codable {
    let username: String
}

struct UserToken: Codable {
    let user: TokenUser
    let expiry: Date
    let token: String
    
    private enum CodingKeys : String, CodingKey { case user, expiry, token }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var rawDate = try container.decode(String.self, forKey: .expiry)
        rawDate = rawDate.replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression)
        expiry = ISO8601DateFormatter().date(from: rawDate)!
        user = try container.decode(TokenUser.self, forKey: .user)
        token = try container.decode(String.self, forKey: .token)
    }
}
