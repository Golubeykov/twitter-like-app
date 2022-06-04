//
//  Firestore+Extension.swift
//  twitterLike
//
//  Created by Антон Голубейков on 04.06.2022.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

// While the FirebaseFirestore package supports async/await, the FirebaseFirestoreSwift package still needs to be updated. Below is implementation of async/await for FirestoreSwift.
extension DocumentReference {
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
//This lets us retrieve documents from a Cloud Firestore query and convert them to a Decodable type in one step
extension Query {
    func getDocuments<T: Decodable>(as type: T.Type) async throws -> [T] {
        let snapshot = try await getDocuments()
        return snapshot.documents.compactMap { document in
            try! document.data(as: type)
        }
    }
}
