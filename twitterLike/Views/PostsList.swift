//
//  PostsList.swift
//  twitterLike
//
//  Created by Антон Голубейков on 30.05.2022.
//

import SwiftUI

// A view for a list of posts (post itself is constructed on PostRow view)

struct PostsList: View {
    private var posts = [Post.testPost]
 
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            List(posts) { post in
                if searchText.isEmpty || post.contains(searchText) {
                PostRow(post: post)
                }
            }
            .searchable(text: $searchText)
            .navigationTitle("Posts")
        }
    }
}

struct PostsList_Previews: PreviewProvider {
    static var previews: some View {
        PostsList()
    }
}
