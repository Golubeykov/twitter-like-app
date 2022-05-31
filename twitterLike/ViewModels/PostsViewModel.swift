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
    
    // Implemententation of create action, that will be called from PostsLists and then sent to NewPostForm.
    func makeCreateAction() -> NewPostForm.CreateAction {
        return { [weak self] post in
            // Upload post to Firestore
            try await self?.postsRepository.create(post)
            // Add post locally
            self?.posts.value?.insert(post, at: 0)
        }
    }
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
}
