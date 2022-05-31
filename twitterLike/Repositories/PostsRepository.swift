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
 
    static func create(_ post: Post) async throws {
        let document = postsReference.document(post.id.uuidString)
        try await document.setData(from: post)
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
