//
//  PostRow.swift
//  twitterLike
//
//  Created by Антон Голубейков on 31.05.2022.
//

import SwiftUI

// A separate view for a post itself. List of PostRow views is presented on  PostsLists view.

struct PostRow: View {
    typealias DeleteAction = () async throws -> Void
    
    let post: Post
    let deleteAction: DeleteAction
    
    @State private var showConfirmationDialog = false
    @State private var error: Error?
    
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
               HStack {
                   Spacer()
                   Button(role: .destructive, action: { showConfirmationDialog = true }, label: { Image(systemName: "trash") })
                       .labelStyle(.iconOnly)
                       .buttonStyle(.borderless)
               }
           }
           .padding(.vertical)
           .confirmationDialog("Are you sure you want to delete this post?", isPresented: $showConfirmationDialog, titleVisibility: .visible) {
               Button("Delete", role: .destructive, action: deletePost)
           }
           .alert("Cannot Delete Post", error: $error)
       }
    // This function to be called when delete button is tapped
    private func deletePost() {
        Task {
            do {
                try await deleteAction()
            } catch {
                print("[PostRow] Cannot delete post: \(error)")
                self.error = error
            }
        }
    }
}

struct PostRow_Previews: PreviewProvider {
    static var testPost = Post.testPost
    static var previews: some View {
        PostRow(post: testPost, deleteAction: {})
    }
}
