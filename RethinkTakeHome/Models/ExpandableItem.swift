//
//  ExpandableItem.swift
//  RethinkTakeHome
//
//  Created by Taylor Simpson on 5/15/23.
//

import Foundation
/// Common Class for Users, Posts, and Comments to be used with Disclsoure Groups
class ExpandableItem: Identifiable, ObservableObject {
    enum ItemType {
        case user(User)
        case post(Post)
        case comment(Comment)
    }
    
    let id: Int
    let title: String
    let type: ItemType
    // these are specific to comment and that is why they are optional
    var email: String?
    var body: String?
    weak var userModel: UsersHandler?
    @Published var children: [ExpandableItem]?
    @Published var isExpanded: Bool = false
    let networkService: NetworkService

        init(id: Int, title: String, type: ItemType, children: [ExpandableItem]?, userModel: UsersHandler?, email: String? = nil, body: String? = nil, networkService: NetworkService) {
            self.id = id
            self.title = title
            self.type = type
            self.children = children
            self.email = email
            self.body = body
            self.userModel = userModel
            self.networkService = networkService
        }
    
    // Function to toggle the isExpanded state and fetch children if not already fetched
    func toggleExpanded() {
        isExpanded.toggle()
        if children == nil {
            Task {
                await fetchChildren()
            }
        }
    }
    
    // Function to fetch children based on the type of the item
    @MainActor
    func fetchChildren() async {
        switch type {
        case .user(let user):
            let postRequest = PostsHandler(networkService: networkService, query: "userId", queryValue: "\(user.id)")
            do {
                try await postRequest.getPosts()
                let posts = postRequest.posts
                userModel?.incrementPostCount(by: posts.count)
                self.children = posts.map { post in
                    ExpandableItem(id: post.id, title: post.title, type: .post(post), children: nil, userModel: userModel, networkService: networkService)
                }
            } catch {
                // handle error
                print("Failed to fetch posts: \(error)")
            }
        case .post(let post):
            let commentRequest = CommentsHandler(networkService: networkService, query: "postId", queryValue: "\(post.id)")
            do {
                try await commentRequest.getComments()
                let comments = commentRequest.comments
                userModel?.incrementCommentCount(by: comments.count)
                self.children = comments.map { comment in
                    ExpandableItem(id: comment.id, title: comment.name, type: .comment(comment), children: nil, userModel: userModel, email: comment.email, body: comment.body, networkService: networkService)
                }
            } catch {
                // handle error
                print("Failed to fetch comments: \(error)")
            }
        case .comment:
            break
        }
    }
    
}
