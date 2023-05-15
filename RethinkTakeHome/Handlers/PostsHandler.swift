//
//  PostsHandler.swift
//  RethinkTakeHome
//
//  Created by Taylor Simpson on 5/15/23.
//

import Foundation
final class PostsHandler {
    var posts = [Post]()
    private var postRequest: ResourceRequest<Post>
    let networkService: NetworkService

    init(networkService: NetworkService = RealNetworkService(), query: String? = nil, queryValue: String? = nil) {
        self.networkService = networkService
        self.postRequest = ResourceRequest(resourcePath: "posts", query: query, queryValue: queryValue, networkService: networkService)
    }
    
    func getPosts() async throws {
        posts = try await postRequest.getAll()
    }
    
}
