//
//  Comments.swift
//  RethinkTakeHome
//
//  Created by Taylor Simpson on 5/10/23.
//

import Foundation
// Comment data model
struct Comment: Codable, Identifiable{
    let id: Int
    let postId: Int
    let name: String
    let email: String
    let body: String
}
