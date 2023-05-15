//
//  CommentView.swift
//  RethinkTakeHome
//
//  Created by Taylor Simpson on 5/11/23.
//

import SwiftUI
struct CommentView: View {
    @ObservedObject var comment: ExpandableItem
    @State private var isExpanded: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            DisclosureGroup(isExpanded: $isExpanded) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Email: \(comment.email ?? "")")
                    Text("Body: \(comment.body ?? "")")
                }
                .padding(.leading, 10)
            } label: {
                Text(comment.title)
                    .font(.title2)
                    .fontWeight(.bold)
            }
            .onTapGesture {
                isExpanded.toggle()
            }
        }
        .padding(10)
        .frame(minWidth: 0, maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
}



