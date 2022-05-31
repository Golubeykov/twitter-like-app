//
//  PostsRepository.swift
//  twitterLike
//
//  Created by Антон Голубейков on 31.05.2022.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct PostsRepository {
    static let postsReference = Firestore.firestore().collection("posts")
    
    //Create post in Firestore from NewPostForm
    static func create(_ post: Post) async throws {
        let document = postsReference.document(post.id.uuidString)
        try await document.setData(from: post)
    }
    //Load posts from Firestore after App start
    static func fetchPosts() async throws -> [Post] {
        //Download a snapshot from Firestore
        let snapshot = try await postsReference
            .order(by: "timestamp", descending: true)
            .getDocuments()
        //Convert snapshot into Post struct
        return snapshot.documents.compactMap {
            document in
            try! document.data(as: Post.self)
        }
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
