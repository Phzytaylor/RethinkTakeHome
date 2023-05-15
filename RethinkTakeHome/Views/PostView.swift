//
//  PostView.swift
//  RethinkTakeHome
//
//  Created by Taylor Simpson on 5/11/23.
//

import SwiftUI
struct PostView: View {
    @ObservedObject var post: ExpandableItem

    var body: some View {
        DisclosureGroup(isExpanded: $post.isExpanded, content: {
            if let children = post.children {
                ForEach(children) { comment in
                    CommentView(comment: comment)
                }
            }
        }, label: {
            Text(post.title)
        })
        .onReceive(post.$isExpanded) { isExpanded in
            // only makes api call if there are no existing children and until expanded
            if isExpanded && post.children == nil {
                Task {
                    await post.fetchChildren()
                }
            }
        }
    }
}
