//
//  CommentsRepository.swift
//  twitterLike
//
//  Created by Антон Голубейков on 04.06.2022.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol CommentsRepositoryProtocol {
    var user: User { get }
    var post: Post { get }
    func fetchComments() async throws -> [Comment]
    func create(_ comment: Comment) async throws
    func delete(_ comment: Comment) async throws
}

//Users can delete comments if they’re the author of the comment—or the post the comment is on
extension CommentsRepositoryProtocol {
    func canDelete(_ comment: Comment) -> Bool {
        [comment.author.id, post.author.id].contains(user.id)
    }
}
//This defines the CommentsRepository with the required properties and methods
struct CommentsRepository: CommentsRepositoryProtocol {
    let user: User
    let post: Post
    
    //Reference to Firestore collection
    private var commentsReference: CollectionReference {
        let postsReference = Firestore.firestore().collection("posts_v2")
        let document = postsReference.document(post.id.uuidString)
        return document.collection("comments")
    }
 
    func fetchComments() async throws -> [Comment] {
        return try await commentsReference
            .order(by: "timestamp", descending: true)
            .getDocuments(as: Comment.self)
    }
 
    func create(_ comment: Comment) async throws {
        let document = commentsReference.document(comment.id.uuidString)
        try await document.setData(from: comment)
    }
 
    func delete(_ comment: Comment) async throws {
        precondition(canDelete(comment))
        let document = commentsReference.document(comment.id.uuidString)
        try await document.delete()
    }
}

#if DEBUG
struct CommentsRepositoryStub: CommentsRepositoryProtocol {
    let user = User.testUser
    let post = Post.testPost
    let state: Loadable<[Comment]>
 
    func fetchComments() async throws -> [Comment] {
        return try await state.simulate()
    }
 
    func create(_ comment: Comment) async throws {}
 
    func delete(_ comment: Comment) async throws {}
}
#endif
