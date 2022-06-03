//
//  PostsViewModel.swift
//  twitterLike
//
//  Created by Антон Голубейков on 31.05.2022.
//

import Foundation

@MainActor
class PostsViewModel: ObservableObject {
    @Published var user: User?

    //MARK: - Filter for tab
    enum Filter {
        case all, favorites
    }
    private let filter: Filter
    var title: String {
        switch filter {
        case .all:
            return "Posts"
        case .favorites:
            return "Favorites"
        }
    }
    //MARK: - Futher implementation
    @Published var posts: Loadable<[Post]> = .loading
    private let postsRepository: PostsRepositoryProtocol
    
    //Initiating default implementation of PostsVM methods
    init(filter: Filter = .all, postsRepository: PostsRepositoryProtocol) {
        self.filter = filter
        self.postsRepository = postsRepository
    }
    
    //MARK: - Fetching posts after app's launch (to be called from PostsList)
    func fetchPosts() {
        Task {
            do {
                posts = .loaded(try await postsRepository.fetchPosts(matching: filter))
            }
            catch {
                print("[PostsViewModel] Cannot fetch posts: \(error)")
                posts = .error(error)
            }
        }
    }

    //MARK: - Produces a PostRowViewModel for the given post
    func makePostRowViewModel(for post: Post) -> PostRowViewModel {
        let deleteAction = { [weak self] in
            try await self?.postsRepository.delete(post)
            self?.posts.value?.removeAll { $0 == post }
        }
        let favoriteAction = { [weak self] in
            let newValue = !post.isFavorite
            try await newValue ? self?.postsRepository.favorite(post) : self?.postsRepository.unfavorite(post)
            guard let i = self?.posts.value?.firstIndex(of: post) else { return }
            self?.posts.value?[i].isFavorite = newValue
        }
        return PostRowViewModel(
            post: post,
            deleteAction: postsRepository.canDelete(post) ? deleteAction : nil,
            favoriteAction: favoriteAction
        )
    }
    //MARK: - Prepares the view model for the NewPostForm
    func makeNewPostViewModel() -> FormViewModel<Post> {
        return FormViewModel<Post>(
            initialValue: Post(title: "", content: "", author: postsRepository.user),
            action: { [weak self] post in
                try await self?.postsRepository.create(post)
                self?.posts.value?.insert(post, at: 0)
            }
        )
    }
}
//MARK: - This method uses a switch statement to call the correct PostsRepository method for our filter
private extension PostsRepositoryProtocol {
    func fetchPosts(matching filter: PostsViewModel.Filter) async throws -> [Post] {
        switch filter {
        case .all:
            return try await fetchAllPosts()
        case .favorites:
            return try await fetchFavoritePosts()
        }
    }
}
