//
//  PostsRepository.swift
//  twitterLike
//
//  Created by Антон Голубейков on 31.05.2022.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol PostsRepositoryProtocol {
    func fetchAllPosts() async throws -> [Post]
    func fetchFavoritePosts() async throws -> [Post]
    func create(_ post: Post) async throws
    func delete(_ post: Post) async throws
    func favorite(_ post: Post) async throws
    func unfavorite(_ post: Post) async throws
    
    var user: User { get }
}

struct PostsRepository: PostsRepositoryProtocol {
    let postsReference = Firestore.firestore().collection("posts_v2")
    let user: User
    
    //MARK: - Helper method that shares logic for fetchAllPosts and fetchFavoritePosts (see below)
    private func fetchPosts(from query: Query) async throws -> [Post] {
        let snapshot = try await query
            .order(by: "timestamp", descending: true)
            .getDocuments()
        return snapshot.documents.compactMap { document in
            try! document.data(as: Post.self)
        }
    }
    
    //MARK: - Load posts from Firestore after App start
    func fetchAllPosts() async throws -> [Post] {
        return try await fetchPosts(from: postsReference)
    }
     
    func fetchFavoritePosts() async throws -> [Post] {
        return try await fetchPosts(from: postsReference.whereField("isFavorite", isEqualTo: true))
    }
    
    //MARK: - Create post in Firestore from NewPostForm
    func create(_ post: Post) async throws {
        let document = postsReference.document(post.id.uuidString)
        try await document.setData(from: post)
    }
    //MARK: - Delete post in Firestore
    func delete(_ post: Post) async throws {
        precondition(canDelete(post))
        let document = postsReference.document(post.id.uuidString)
        try await document.delete()
    }
    //MARK: - Favorite post
    func favorite(_ post: Post) async throws {
        let document = postsReference.document(post.id.uuidString)
        try await document.setData(["isFavorite": true], merge: true)
    }
    //MARK: - Unfavorite post
    func unfavorite(_ post: Post) async throws {
        let document = postsReference.document(post.id.uuidString)
        try await document.setData(["isFavorite": false], merge: true)
    }
}
//MARK: - This defines a canDelete(_:) method that returns true when the post’s author ID matches the ID of the current user.
extension PostsRepositoryProtocol {
    func canDelete(_ post: Post) -> Bool {
        post.author.id == user.id
    }
}

// While the FirebaseFirestore package supports async/await, the FirebaseFirestoreSwift package still needs to be updated. Below is implementation of async/await for FirestoreSwift.
private extension DocumentReference {
    func setData<T: Encodable>(from value: T) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            // Method only throws if there’s an encoding error, which indicates a problem with our model.
            // We handled this with a force try, while all other errors are passed to the completion handler.
            try! setData(from: value) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                continuation.resume()
            }
        }
    }
}

// case when we load empty array of posts
#if DEBUG
struct PostsRepositoryStub: PostsRepositoryProtocol {
    let state: Loadable<[Post]>
 
    func fetchAllPosts() async throws -> [Post] {
        return try await state.simulate()
    }
    
    func fetchFavoritePosts() async throws -> [Post] {
        return try await state.simulate()
    }
 
    func create(_ post: Post) async throws {}
    
    func delete(_ post: Post) async throws {}
    
    func favorite(_ post: Post) async throws {}
 
    func unfavorite(_ post: Post) async throws {}
    
    var user = User.testUser
}
#endif
