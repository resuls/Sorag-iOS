//
//  Endoints.swift
//  Sorag
//
//  Created by Resul on 07.02.20.
//  Copyright © 2020 Resulkary Saparov. All rights reserved.
//
import Foundation

class Endpoints {
    private static let host = "http://192.168.0.102:8003/api/v1/"
    
    enum API {
        static let login = URL(string: host + "login/")!
        static let logout = URL(string: host + "logout/")!
    }
}
