//
//  UserView.swift
//  RethinkTakeHome
//
//  Created by Taylor Simpson on 5/11/23.
//

import SwiftUI
struct UserView: View {
    @ObservedObject var user: ExpandableItem

    var body: some View {
        DisclosureGroup(isExpanded: $user.isExpanded, content: {
            if let children = user.children {
                ForEach(children) { post in
                    PostView(post: post)
                }
            }
        }, label: {
            Text(user.title)
        })
        .onReceive(user.$isExpanded) { isExpanded in
            // only makes api call if there are no existing children and until expanded
            if isExpanded && user.children == nil {
                Task {
                    await user.fetchChildren()
                }
            }
        }
    }
}
