//
//  Register.swift
//  Sorag
//
//  Created by Resul on 09.02.20.
//  Copyright © 2020 Resulkary Saparov. All rights reserved.
//

import Foundation

struct UserRegister: Codable {
    let username: [String]?
    let password: [String]?
    let email: [String]?
    let first_name: [String]?
    let last_name: [String]?
}
