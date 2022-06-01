//
//  PostRowViewModel.swift
//  twitterLike
//
//  Created by Антон Голубейков on 01.06.2022.
//

import Foundation

@MainActor
@dynamicMemberLookup
class PostRowViewModel: ObservableObject {
    typealias Action = () async throws -> Void
 
    @Published var post: Post
    @Published var error: Error?
 
    private let deleteAction: Action
    private let favoriteAction: Action
 
    init(post: Post, deleteAction: @escaping Action, favoriteAction: @escaping Action) {
        self.post = post
        self.deleteAction = deleteAction
        self.favoriteAction = favoriteAction
    }
    //MARK: - Method, that encapsulate shared logic of func favoritePost() / deletePost() (see next)
    private func withErrorHandlingTask(perform action: @escaping Action) {
        Task {
            do {
                try await action()
            } catch {
                print("[PostRowViewModel] Error: \(error)")
                self.error = error
            }
        }
    }
    //MARK: - Functions, that are being called after button tap
    func deletePost() {
        withErrorHandlingTask(perform: deleteAction)
    }
     
    func favoritePost() {
        withErrorHandlingTask(perform: favoriteAction)
    }
    //MARK: - That helps us to call Post's properties directly (e.g. Text(viewModel.content) instead of Text(viewModel.post.content)
    subscript<T>(dynamicMember keyPath: KeyPath<Post, T>) -> T {
        post[keyPath: keyPath]
    }
}
