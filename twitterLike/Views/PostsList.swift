//
//  PostsList.swift
//  twitterLike
//
//  Created by Антон Голубейков on 30.05.2022.
//

import SwiftUI

// A view for a list of posts (post itself is constructed on PostRow view)

struct PostsList: View {
    @StateObject var viewModel: PostsViewModel
 
    @State private var searchText = ""
    @State private var showNewPostForm = false
    
    var body: some View {
        NavigationView {
            Group {
                //Depending on network call result different views are presented
                switch viewModel.posts {
                case .loading:
                    ProgressView()
                case let .error(error):
                    EmptyListView(
                        title: "Cannot Load Posts",
                        message: error.localizedDescription,
                        retryAction: {
                            viewModel.fetchPosts()
                        }
                    )
                case .empty:
                    EmptyListView(
                        title: "No Posts",
                        message: "There aren’t any posts yet."
                    )
                case let .loaded(posts):
                    List(posts) { post in
                        if searchText.isEmpty || post.contains(searchText) {
                            PostRow(viewModel: viewModel.makePostRowViewModel(for: post))
                        }
                    }
                    .searchable(text: $searchText)
                    .animation(.default, value: posts)
                }
            }
            .searchable(text: $searchText)
            .navigationTitle(viewModel.title)
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    Button(action: { showNewPostForm = true }, label: { Image(systemName: "square.and.pencil") })
                })
            })
            .sheet(isPresented: $showNewPostForm, content: {
                NewPostForm(viewModel: viewModel.makeNewPostViewModel())
            })
            .onAppear {
                viewModel.fetchPosts()
            }
        }
    }
}

#if DEBUG
struct PostsList_Previews: PreviewProvider {
    @MainActor
    private struct ListPreview: View {
        let state: Loadable<[Post]>
     
        var body: some View {
            let postsRepository = PostsRepositoryStub(state: state)
            let viewModel = PostsViewModel(postsRepository: postsRepository)
            PostsList(viewModel: viewModel)
        }
    }
    static var previews: some View {
        ListPreview(state: .loaded([Post.testPost]))
        ListPreview(state: .empty)
        ListPreview(state: .error)
        ListPreview(state: .loading)
    }
}
#endif
