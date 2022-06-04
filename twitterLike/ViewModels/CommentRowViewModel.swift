//
//  CommentRowViewModel.swift
//  twitterLike
//
//  Created by Антон Голубейков on 04.06.2022.
//

import Foundation

//This view model is a thin wrapper around the Comment type. Like the PostRowViewModel, we used dynamic member lookup, meaning that we can subscript the view model as if it were a Comment.
@MainActor
@dynamicMemberLookup
class CommentRowViewModel: ObservableObject, ErrorHandler {
    typealias Action = () async throws -> Void
    
    @Published var comment: Comment
    @Published var error: Error?
    
    var canDeleteComment: Bool { deleteAction != nil }
    
    subscript<T>(dynamicMember keyPath: KeyPath<Comment, T>) -> T {
        comment[keyPath: keyPath]
    }
    
    private let deleteAction: Action?
    
    init(comment: Comment, deleteAction: Action?) {
        self.comment = comment
        self.deleteAction = deleteAction
    }
    
    func deleteComment() {
        guard let deleteAction = deleteAction else {
            preconditionFailure("Cannot delete comment: no delete action provided")
        }
        withErrorHandlingTask(perform: deleteAction)
    }
}
