//
//  PostsList.swift
//  twitterLike
//
//  Created by Антон Голубейков on 30.05.2022.
//

import SwiftUI

// A view for a list of posts (post itself is constructed on PostRow view)

struct PostsList: View {
    @StateObject var viewModel = PostsViewModel()
 
    @State private var searchText = ""
    @State private var showNewPostForm = false
    
    var body: some View {
        NavigationView {
            List(viewModel.posts) { post in
                if searchText.isEmpty || post.contains(searchText) {
                PostRow(post: post)
                }
            }
            .searchable(text: $searchText)
            .navigationTitle("Posts")
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    Button(action: { showNewPostForm = true }, label: { Image(systemName: "square.and.pencil") })
                })
            })
            .sheet(isPresented: $showNewPostForm, content: {
                NewPostForm(createAction: viewModel.makeCreateAction())
            })
        }
    }
}

struct PostsList_Previews: PreviewProvider {
    static var previews: some View {
        PostsList()
    }
}
