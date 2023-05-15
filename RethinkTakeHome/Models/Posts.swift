//
//  Posts.swift
//  RethinkTakeHome
//
//  Created by Taylor Simpson on 5/10/23.
//

import Foundation

/// Post data model
struct Post: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
