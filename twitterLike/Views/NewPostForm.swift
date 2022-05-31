//
//  NewPostForm.swift
//  twitterLike
//
//  Created by Антон Голубейков on 31.05.2022.
//

import SwiftUI

struct NewPostForm: View {
    @State private var post = Post(title: "", content: "", authorName: "")
    @State private var state = FormState.idle
    
    // Dismiss modal view
    @Environment(\.dismiss) private var dismiss
    
    //Closure for a post creation (implementation is recieved from viewModel)
    typealias CreateAction = (Post) async throws -> Void
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
                    if state == .working {
                        ProgressView()
                    } else {
                        Text("Create Post")
                    }
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
        //Disable view while network call
        .disabled(state == .working)
        .alert("Cannot Create Post", isPresented: $state.isError, actions: {}, message: {Text("Sorry, something went wrong.")})
    }
    
    //Function, initiating creation of a post
    private func createPost() {
        Task {
            state = .working
            do {
                try await createAction(post)
                dismiss()
            } catch {
                print("[NewPostForm] Cannot create post: \(error)")
                state = .error
            }
        }
    }
}

private extension NewPostForm {
    enum FormState {
        case idle, working, error
        
        var isError: Bool {
            get {
                self == .error
            }
            set {
                guard !newValue else { return }
                self = .idle
            }
        }
    }
}

struct NewPostForm_Previews: PreviewProvider {
    static var previews: some View {
        NewPostForm(createAction: { _ in return })
    }
}
