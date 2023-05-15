//
//  Users.swift
//  RethinkTakeHome
//
//  Created by Taylor Simpson on 5/10/23.
//

import Foundation

/// User Data model
struct User: Codable, Identifiable {
    let id: Int
    let name, username, email: String
    let address: Address
    let phone, website: String
    let company: Company
}

struct Address: Codable {
    let street, suite, city, zipcode: String
    let geo: Geo
}

struct Geo: Codable {
    let lat, lng: String
}

struct Company: Codable {
    let name, catchPhrase, bs: String
}
