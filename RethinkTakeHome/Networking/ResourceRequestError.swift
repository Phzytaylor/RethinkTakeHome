//
//  ResourceRequestError.swift
//  RethinkTakeHome
//
//  Created by Taylor Simpson on 5/10/23.
//

import Foundation
enum ResourceRequestError: Error {
    case noData
    case decodingError
    case encodingError
    case notAuthorized
}
