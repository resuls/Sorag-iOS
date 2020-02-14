//
//  Question.swift
//  Sorag
//
//  Created by Resul on 12.02.20.
//  Copyright © 2020 Resulkary Saparov. All rights reserved.
//

import Foundation

struct Question: Codable {
    let url: String
    let owner: String
    let id: Int
    let first_name: String
    let last_name: String
    let date: String
    let title: String
    let text: String
    let upvotes: Int
    let downvotes: Int
    let upvoted: Bool
    let downvoted: Bool
}

struct Questions: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Question]
}
