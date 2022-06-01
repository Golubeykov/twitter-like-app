//
//  PostsViewModel.swift
//  twitterLike
//
//  Created by Антон Голубейков on 31.05.2022.
//

import Foundation

@MainActor
class PostsViewModel: ObservableObject {
    @Published var posts: Loadable<[Post]> = .loading
    private let postsRepository: PostsRepositoryProtocol
    
    //Initiating default implementation of PostsVM methods
    init(postsRepository: PostsRepositoryProtocol = PostsRepository()) {
        self.postsRepository = postsRepository
    }
    
    //MARK: - Fetching posts after app's launch (to be called from PostsList)
    func fetchPosts() {
        Task {
            do {
                posts = .loaded(try await postsRepository.fetchPosts())
            }
            catch {
                print("[PostsViewModel] Cannot fetch posts: \(error)")
                posts = .error(error)
            }
        }
    }
    //MARK: - Implemententation of create action, that will be called from NewPostForm (but sent there via PostsList).
    func makeCreateAction() -> NewPostForm.CreateAction {
        return { [weak self] post in
            // Upload post to Firestore
            try await self?.postsRepository.create(post)
            // Add post locally
            self?.posts.value?.insert(post, at: 0)
        }
    }
    //MARK: - Delete action (to be called from PostRow)
    func makeDeleteAction(for post: Post) -> PostRow.DeleteAction {
        return { [weak self] in
            try await self?.postsRepository.delete(post)
            self?.posts.value?.removeAll { $0.id == post.id }
        }
    }
}
