//
//  UsersHandler.swift
//  RethinkTakeHome
//
//  Created by Taylor Simpson on 5/10/23.
//

import Foundation
import SwiftUI
import CoreLocation

/// Grabs the users data and transforms the data for the view
@MainActor
final class UsersHandler: ObservableObject {
    @Published var users = [ExpandableItem]()
    @Published var isLoading = false
    @Published var userCount = 0
    @Published var postCount = 0
    @Published var commentCount = 0
    @Published var isFetchingAll = false
    
    private var userRequest: ResourceRequest<User>
        let networkService: NetworkService

        init(networkService: NetworkService = RealNetworkService()) {
            self.networkService = networkService
            self.userRequest = ResourceRequest<User>(resourcePath: "users", networkService: networkService)
        }
    
    func getUsers() async throws {
        isLoading = true
        let userData = try await userRequest.getAll()
        users = userData.map { ExpandableItem(id: $0.id, title: $0.name, type: .user($0), children: nil, userModel: self, email: $0.email, networkService: networkService) }
        userCount = users.count
        isLoading = false
    }
    
    // increments posts count as posts are feteched
    func incrementPostCount(by amount: Int) {
        postCount += amount
    }
    
    // increments comments count as posts are feteched
    func incrementCommentCount(by amount: Int) {
        commentCount += amount
    }
}
