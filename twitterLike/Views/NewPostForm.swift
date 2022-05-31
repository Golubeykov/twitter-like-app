//
//  NewPostForm.swift
//  twitterLike
//
//  Created by Антон Голубейков on 31.05.2022.
//

import SwiftUI

struct NewPostForm: View {
    @State private var post = Post(title: "", content: "", authorName: "")
    
    // Dismiss modal view
    @Environment(\.dismiss) private var dismiss
    
    //Closure for a post creation (implementation is recieved from viewModel)
    typealias CreateAction = (Post) -> Void
    let createAction: CreateAction
    
    //Body of the view
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Title", text: $post.title)
                    TextField("Author Name", text: $post.authorName)
                }
                Section("Content") {
                    TextEditor(text: $post.content)
                        .multilineTextAlignment(.leading)
                }
                Button(action: createPost) {
                    Text("Create Post")
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .padding()
                .listRowBackground(Color.accentColor)
            }
            .navigationTitle("New Post")
            .onSubmit(createPost)
        }
    }
    
    //Function, initiating creation of a post
    private func createPost() {
        createAction(post)
        dismiss()
    }
}

struct NewPostForm_Previews: PreviewProvider {
    static var previews: some View {
        NewPostForm(createAction: { _ in return })
    }
}
