//
//  Endoints.swift
//  Sorag
//
//  Created by Resul on 07.02.20.
//  Copyright © 2020 Resulkary Saparov. All rights reserved.
//
import Foundation

class Endpoints {
    private static let host = "https://sorag-b.herokuapp.com/api/v1/"
    
    enum API {
        static let login = URL(string: host + "login/")!
        static let logout = URL(string: host + "logout/")!
        static let users = URL(string: host + "users/")!
        static let questions = URL(string: host + "questions/")!
    }
}
