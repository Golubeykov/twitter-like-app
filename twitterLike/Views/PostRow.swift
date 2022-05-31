//
//  PostRow.swift
//  twitterLike
//
//  Created by Антон Голубейков on 31.05.2022.
//

import SwiftUI

// A separate view for a post itself. List of PostRow views is presented on  PostsLists view.

struct PostRow: View {
    let post: Post
    
    var body: some View {
           VStack(alignment: .leading, spacing: 10) {
               HStack {
                   Text(post.authorName)
                       .font(.subheadline)
                       .fontWeight(.medium)
                   Spacer()
                   Text(post.timestamp.formatted(date: .abbreviated, time: .omitted))
                       .font(.caption)
               }
               .foregroundColor(.gray)
               Text(post.title)
                   .font(.title3)
                   .fontWeight(.semibold)
               Text(post.content)
           }
           .padding(.vertical)
       }
}

struct PostRow_Previews: PreviewProvider {
    static var testPost = Post.testPost
    static var previews: some View {
        PostRow(post: testPost)
    }
}
