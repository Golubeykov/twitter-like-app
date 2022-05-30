//
//  PostsList.swift
//  twitterLike
//
//  Created by Антон Голубейков on 30.05.2022.
//

import SwiftUI

struct PostsList: View {
    private var posts = [Post.testPost]
 
    var body: some View {
        List(posts) { post in
            Text(post.content)
        }
    }
}

struct PostsList_Previews: PreviewProvider {
    static var previews: some View {
        PostsList()
    }
}
