//
//  PostRow.swift
//  twitterLike
//
//  Created by Антон Голубейков on 31.05.2022.
//

import SwiftUI

// A separate view for a post itself. List of PostRow views is presented on  PostsLists view.

struct PostRow: View {
    @ObservedObject var viewModel: PostRowViewModel
    @EnvironmentObject private var factory: ViewModelFactory
    
    @State private var showConfirmationDialog = false
    
    var body: some View {
           VStack(alignment: .leading, spacing: 10) {
               HStack {
                   AuthorView(author: viewModel.author)
                   Spacer()
                   Text(viewModel.timestamp.formatted(date: .abbreviated, time: .omitted))
                       .font(.caption)
               }
               .foregroundColor(.gray)
               Text(viewModel.title)
                   .font(.title3)
                   .fontWeight(.semibold)
               Text(viewModel.content)
               HStack {
                   FavoriteButton(isFavorite: viewModel.isFavorite, action: { viewModel.favoritePost() })
                   NavigationLink {
                       CommentsList(viewModel: factory.makeCommentsViewModel(for: viewModel.post))
                   } label: {
                       Label("Comments", systemImage: "text.bubble")
                           .foregroundColor(.secondary)
                   }
                   Spacer()
                   if viewModel.canDeletePost {
                       Button(role: .destructive, action: {
                           showConfirmationDialog = true
                       }) {
                           Label("Delete", systemImage: "trash")
                       }
                   }
               }
               .labelStyle(.iconOnly)
           }
           .padding()
           .confirmationDialog("Are you sure you want to delete this post?", isPresented: $showConfirmationDialog, titleVisibility: .visible) {
               Button("Delete", role: .destructive, action: { viewModel.deletePost() })
           }
           .alert("Error", error: $viewModel.error)
       }

}

//MARK: - Implementation of "favorite" button
private extension PostRow {
    struct FavoriteButton: View {
        let isFavorite: Bool
        let action: () -> Void
 
        var body: some View {
            Button(action: action) {
                if isFavorite {
                    Label("Remove from Favorites", systemImage: "heart.fill")
                } else {
                    Label("Add to Favorites", systemImage: "heart")
                }
            }
            .foregroundColor(isFavorite ? .red : .gray)
            .animation(.default, value: isFavorite)
        }
    }
}
//MARK: - This defines the AuthorView, which consists of a NavigationLink labeled with the author’s name. When we tap the link, we used the ViewModelFactory to display a PostsList with all of the author’s posts.
private extension PostRow {
    struct AuthorView: View {
        let author: User
     
        @EnvironmentObject private var factory: ViewModelFactory
     
        var body: some View {
            NavigationLink {
                PostsList(viewModel: factory.makePostsViewModel(filter: .author(author)))
            } label: {
                Text(author.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
        }
    }
}

struct PostRow_Previews: PreviewProvider {
    static var previews: some View {
        PostRow(viewModel: PostRowViewModel(post: Post.testPost, deleteAction: {}, favoriteAction: {}))
            .previewLayout(.sizeThatFits)
    }
}

