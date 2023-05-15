//
//  ContentView.swift
//  RethinkTakeHome
//
//  Created by Taylor Simpson on 5/10/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var userModel = UsersHandler()
    @State private var showCountAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            List {
                if userModel.isLoading {
                    ProgressView()
                } else {
                    ForEach(userModel.users) { user in
                        UserView(user: user)
                    }
                }
            }
            .navigationTitle("Taylor Rethink Interview").navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    // A button that when pressed, calculates and displays the number of users, posts, and comments in an alert
                    Button(action: {
                        let userCount = userModel.userCount
                        let postCount = userModel.postCount
                        let commentCount = userModel.commentCount
                        alertMessage = "Users: \(userCount)\nPosts: \(postCount)\nComments: \(commentCount)"
                        showCountAlert = true
                    }) {
                        Text("Count")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        Task {
                            do {
                                // Reset the children to nil to force a refresh
                                userModel.users.forEach { $0.children = nil }
                                try await userModel.getUsers()
                            } catch(let error) {
                                print(error.localizedDescription)
                            }
                        }
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
            .alert("Count", isPresented: $showCountAlert, actions: {
                Button("OK", role: .cancel) {
                    
                }
            }, message: {
                Text(alertMessage)
            })
        }
        .task {
            // When the view appears, retrieve the users
            do {
                try await userModel.getUsers()
            } catch(let error) {
                print(error.localizedDescription)
            }
        }
    }
}





struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
