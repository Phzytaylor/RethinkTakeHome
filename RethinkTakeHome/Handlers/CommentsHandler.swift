//
//  CommentsHandler.swift
//  RethinkTakeHome
//
//  Created by Taylor Simpson on 5/15/23.
//

import Foundation
final class CommentsHandler {
    var comments = [Comment]()
    private var commentRequest: ResourceRequest<Comment>
    let networkService: NetworkService

    init(networkService: NetworkService = RealNetworkService(), query: String? = nil, queryValue: String? = nil) {
        self.networkService = networkService
        self.commentRequest = ResourceRequest<Comment>(resourcePath: "comments", query: query, queryValue: queryValue, networkService: networkService)
    }
    
    func getComments() async throws {
        comments = try await commentRequest.getAll()
    }
    
}
