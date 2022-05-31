//
//  PostsViewModel.swift
//  twitterLike
//
//  Created by Антон Голубейков on 31.05.2022.
//

import Foundation

@MainActor
class PostsViewModel: ObservableObject {
    @Published var posts = [Post.testPost]
    
    // Implemententation of create action, that will be called from PostsLists and then sent to NewPostForm
    func makeCreateAction() -> NewPostForm.CreateAction {
        return { [weak self] post in
            self?.posts.insert(post, at: 0)
        }
    }
}
