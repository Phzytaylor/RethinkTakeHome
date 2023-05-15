//
//  RethinkTakeHomeTests.swift
//  RethinkTakeHomeTests
//
//  Created by Taylor Simpson on 5/10/23.
//

import XCTest
@testable import RethinkTakeHome

class UsersHandlerTests: XCTestCase {
    var mockNetworkService: MockNetworkService!
    var usersHandler: UsersHandler!
    
    @MainActor override func setUp() {
        super.setUp()
        
        // We prepare the mock data and response for the network service.
        let mockData = """
        [
             {
                "id": 1,
                "name": "Leanne Graham",
                "username": "Bret",
                "email": "Sincere@april.biz",
                "address": {
                  "street": "Kulas Light",
                  "suite": "Apt. 556",
                  "city": "Gwenborough",
                  "zipcode": "92998-3874",
                  "geo": {
                    "lat": "-37.3159",
                    "lng": "81.1496"
                  }
                },
                "phone": "1-770-736-8031 x56442",
                "website": "hildegard.org",
                "company": {
                  "name": "Romaguera-Crona",
                  "catchPhrase": "Multi-layered client-server neural-net",
                  "bs": "harness real-time e-markets"
                }
              },
              {
                "id": 2,
                "name": "Ervin Howell",
                "username": "Antonette",
                "email": "Shanna@melissa.tv",
                "address": {
                  "street": "Victor Plains",
                  "suite": "Suite 879",
                  "city": "Wisokyburgh",
                  "zipcode": "90566-7771",
                  "geo": {
                    "lat": "-43.9509",
                    "lng": "-34.4618"
                  }
                },
                "phone": "010-692-6593 x09125",
                "website": "anastasia.net",
                "company": {
                  "name": "Deckow-Crist",
                  "catchPhrase": "Proactive didactic contingency",
                  "bs": "synergize scalable supply-chains"
                }
              }
        ]
        """.data(using: .utf8)!
        
        let mockResponse = HTTPURLResponse(url: URL(string: "https://jsonplaceholder.typicode.com/users")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        mockNetworkService = MockNetworkService(responses: [mockResponse.url! : (mockData, mockResponse)])
        
        // We create a resource request with the mock network service and pass it to the users handler.
        usersHandler = UsersHandler(networkService: mockNetworkService)
    }
    
    @MainActor
    func testGetUsers() async throws {
        try await usersHandler.getUsers()
        
        XCTAssertEqual(usersHandler.users.count, 2)
        XCTAssertEqual(usersHandler.users[0].id, 1)
        XCTAssertEqual(usersHandler.users[0].title, "Leanne Graham")
        XCTAssertEqual(usersHandler.users[0].email, "Sincere@april.biz")
        XCTAssertEqual(usersHandler.users[1].id, 2)
        XCTAssertEqual(usersHandler.users[1].title, "Ervin Howell")
        XCTAssertEqual(usersHandler.users[1].email, "Shanna@melissa.tv")
    }
}

class PostsHandlerTests: XCTestCase {
    var mockNetworkService: MockNetworkService!
    var postsHandler: PostsHandler!
    
    @MainActor override func setUp() {
        super.setUp()
        
        let mockData = """
        [
            {
                "userId": 1,
                "id": 1,
                "title": "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
                "body": "quia et suscipit\\nsuscipit recusandae consequuntur expedita et cum\\nreprehenderit molestiae ut ut quas totam\\nnostrum rerum est autem sunt rem eveniet architecto"
            },
            {
                "userId": 1,
                "id": 2,
                "title": "qui est esse",
                "body": "est rerum tempore vitae\\nsequi sint nihil reprehenderit dolor beatae ea dolores neque\\nfugiat blanditiis voluptate porro vel nihil molestiae ut reiciendis\\nqui aperiam non debitis possimus qui neque nisi nulla"
            }
        ]
        """.data(using: .utf8)!
        
        let mockResponse = HTTPURLResponse(url: URL(string: "https://jsonplaceholder.typicode.com/posts")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        mockNetworkService = MockNetworkService(responses: [mockResponse.url! : (mockData, mockResponse)])
        
        postsHandler = PostsHandler(networkService: mockNetworkService)
    }
    
    @MainActor
    func testGetPosts() async throws {
        try await postsHandler.getPosts()
        XCTAssertEqual(postsHandler.posts.count, 2)
        XCTAssertEqual(postsHandler.posts[0].id, 1)
        XCTAssertEqual(postsHandler.posts[0].title, "sunt aut facere repellat provident occaecati excepturi optio reprehenderit")
        XCTAssertEqual(postsHandler.posts[0].body, "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto")
        XCTAssertEqual(postsHandler.posts[1].id, 2)
        XCTAssertEqual(postsHandler.posts[1].title, "qui est esse")
        XCTAssertEqual(postsHandler.posts[1].body, "est rerum tempore vitae\nsequi sint nihil reprehenderit dolor beatae ea dolores neque\nfugiat blanditiis voluptate porro vel nihil molestiae ut reiciendis\nqui aperiam non debitis possimus qui neque nisi nulla")
    }
}



/// This test runs slow on purpose to simulate opening a user -> posts -> comments
class CommentsHandlerTests: XCTestCase {
    var mockNetworkService: MockNetworkService!
    var commentsHandler: CommentsHandler!

    @MainActor override func setUp() {
        super.setUp()

        let mockData = """
        [
            {
                "postId": 1,
                "id": 1,
                "name": "id labore ex et quam laborum",
                "email": "Eliseo@gardner.biz",
                "body": "laudantium enim quasi est quidem magnam voluptate ipsam eos\\ntempora quo necessitatibus\\ndolor quam autem quasi\\nreiciendis et nam sapiente accusantium"
              },
              {
                "postId": 1,
                "id": 2,
                "name": "quo vero reiciendis velit similique earum",
                "email": "Jayne_Kuhic@sydney.com",
                "body": "est natus enim nihil est dolore omnis voluptatem numquam\\net omnis occaecati quod ullam at\\nvoluptatem error expedita pariatur\\nnihil sint nostrum voluptatem reiciendis et"
              }
        ]
        """.data(using: .utf8)!

        let mockResponse = HTTPURLResponse(url: URL(string: "https://jsonplaceholder.typicode.com/comments")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        mockNetworkService = MockNetworkService(responses: [mockResponse.url! : (mockData, mockResponse)])

        commentsHandler = CommentsHandler(networkService: mockNetworkService)
    }

    @MainActor
    func testGetComments() async throws {
        try await commentsHandler.getComments()
        XCTAssertEqual(commentsHandler.comments.count, 2)
        XCTAssertEqual(commentsHandler.comments[0].id, 1)
        XCTAssertEqual(commentsHandler.comments[0].email, "Eliseo@gardner.biz")
        XCTAssertEqual(commentsHandler.comments[0].body, "laudantium enim quasi est quidem magnam voluptate ipsam eos\ntempora quo necessitatibus\ndolor quam autem quasi\nreiciendis et nam sapiente accusantium")
        XCTAssertEqual(commentsHandler.comments[1].id, 2)
        XCTAssertEqual(commentsHandler.comments[1].email, "Jayne_Kuhic@sydney.com")
        XCTAssertEqual(commentsHandler.comments[1].body, "est natus enim nihil est dolore omnis voluptatem numquam\net omnis occaecati quod ullam at\nvoluptatem error expedita pariatur\nnihil sint nostrum voluptatem reiciendis et")
    }
}

class ExpandableItemTests: XCTestCase {
    var mockNetworkService: MockNetworkService!
    var usersHandler: UsersHandler!

    @MainActor override func setUp() {
        super.setUp()
    }

    @MainActor
    func testFetchChildren() async throws {
        // Prepare the mock data and responses for the network service.
        let mockUsersData = """
        [
             {
                "id": 1,
                "name": "Leanne Graham",
                "username": "Bret",
                "email": "Sincere@april.biz",
                "address": {
                  "street": "Kulas Light",
                  "suite": "Apt. 556",
                  "city": "Gwenborough",
                  "zipcode": "92998-3874",
                  "geo": {
                    "lat": "-37.3159",
                    "lng": "81.1496"
                  }
                },
                "phone": "1-770-736-8031 x56442",
                "website": "hildegard.org",
                "company": {
                  "name": "Romaguera-Crona",
                  "catchPhrase": "Multi-layered client-server neural-net",
                  "bs": "harness real-time e-markets"
                }
              },
              {
                "id": 2,
                "name": "Ervin Howell",
                "username": "Antonette",
                "email": "Shanna@melissa.tv",
                "address": {
                  "street": "Victor Plains",
                  "suite": "Suite 879",
                  "city": "Wisokyburgh",
                  "zipcode": "90566-7771",
                  "geo": {
                    "lat": "-43.9509",
                    "lng": "-34.4618"
                  }
                },
                "phone": "010-692-6593 x09125",
                "website": "anastasia.net",
                "company": {
                  "name": "Deckow-Crist",
                  "catchPhrase": "Proactive didactic contingency",
                  "bs": "synergize scalable supply-chains"
                }
              }
        ]
        """.data(using: .utf8)!
        
        let mockPostsData = """
        [
            {
                "userId": 1,
                "id": 1,
                "title": "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
                "body": "quia et suscipit\\nsuscipit recusandae consequuntur expedita et cum\\nreprehenderit molestiae ut ut quas totam\\nnostrum rerum est autem sunt rem eveniet architecto"
            },
            {
                "userId": 1,
                "id": 2,
                "title": "qui est esse",
                "body": "est rerum tempore vitae\\nsequi sint nihil reprehenderit dolor beatae ea dolores neque\\nfugiat blanditiis voluptate porro vel nihil molestiae ut reiciendis\\nqui aperiam non debitis possimus qui neque nisi nulla"
            }
        ]
        """.data(using: .utf8)!
        
        let mockCommentsData = """
        [
            {
                "postId": 1,
                "id": 1,
                "name": "id labore ex et quam laborum",
                "email": "Eliseo@gardner.biz",
                "body": "laudantium enim quasi est quidem magnam voluptate ipsam eos\\ntempora quo necessitatibus\\ndolor quam autem quasi\\nreiciendis et nam sapiente accusantium"
              },
              {
                "postId": 1,
                "id": 2,
                "name": "quo vero reiciendis velit similique earum",
                "email": "Jayne_Kuhic@sydney.com",
                "body": "est natus enim nihil est dolore omnis voluptatem numquam\\net omnis occaecati quod ullam at\\nvoluptatem error expedita pariatur\\nnihil sint nostrum voluptatem reiciendis et"
              }
        ]
        """.data(using: .utf8)!
        
        let usersResponse = HTTPURLResponse(url: URL(string: "https://jsonplaceholder.typicode.com/users")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        let postsResponse = HTTPURLResponse(url: URL(string: "https://jsonplaceholder.typicode.com/posts")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        
        let commentsResponse = HTTPURLResponse(url: URL(string: "https://jsonplaceholder.typicode.com/comments?postId=1")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        
        let responses: [URL: (Data, URLResponse)] = [
            URL(string: "https://jsonplaceholder.typicode.com/users")!: (mockUsersData, usersResponse),
            URL(string: "https://jsonplaceholder.typicode.com/posts?userId=1")!: (mockPostsData, postsResponse),
            URL(string: "https://jsonplaceholder.typicode.com/comments?postId=1")!: (mockCommentsData, commentsResponse),
            URL(string: "https://jsonplaceholder.typicode.com/comments?postId=2")!: (mockCommentsData, commentsResponse)
        ]
        
        let mockNetworkService = MockNetworkService(responses: responses)
        
        let usersHandler = UsersHandler(networkService: mockNetworkService)
        
        try await usersHandler.getUsers()
        let expandableUserItem = usersHandler.users[0]
        
        expandableUserItem.toggleExpanded()
        
        // Wait until fetchChildren completes.
        while expandableUserItem.children == nil {
            try await Task.sleep(nanoseconds: 1_000_000)
        }
        
        XCTAssertEqual(expandableUserItem.children?.count, 2) // Assuming there are 2 posts for this user.
        
        XCTAssertEqual(expandableUserItem.children?[0].id, 1)
        XCTAssertEqual(expandableUserItem.children?[0].title, "sunt aut facere repellat provident occaecati excepturi optio reprehenderit")
        
        XCTAssertEqual(expandableUserItem.children?[1].id, 2)
        XCTAssertEqual(expandableUserItem.children?[1].title, "qui est esse")
        
        // Toggle expanded to fetch comments for each post.
        for i in 0..<(expandableUserItem.children?.count ?? 0) {
            expandableUserItem.children?[i].toggleExpanded()
            
            // Wait until fetchChildren completes.
            while expandableUserItem.children?[i].children == nil {
                try await Task.sleep(nanoseconds: 1_000_000)
            }
            
            // Check the number of comments for each post.
            XCTAssertEqual(expandableUserItem.children?[i].children?.count, 2)
        }
    }
}
