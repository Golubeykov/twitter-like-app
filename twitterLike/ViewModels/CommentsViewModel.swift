//
//  CommentsViewModel.swift
//  twitterLike
//
//  Created by Антон Голубейков on 04.06.2022.
//

import Foundation

@MainActor
class CommentsViewModel: ObservableObject {
    @Published var comments: Loadable<[Comment]> = .loading
 
    private let commentsRepository: CommentsRepositoryProtocol
 
    init(commentsRepository: CommentsRepositoryProtocol) {
        self.commentsRepository = commentsRepository
    }
    
    func fetchComments() {
        Task {
            do {
                comments = .loaded(try await commentsRepository.fetchComments())
            } catch {
                print("[CommentsViewModel] Cannot fetch comments: \(error)")
                comments = .error(error)
            }
        }
    }
    //This produces a FormViewModel that’s initially set to an empty comment. The action calls the create(_:) method of our CommentsRepository and adds the new comment to the list.
    func makeNewCommentViewModel() -> FormViewModel<Comment> {
        return FormViewModel<Comment>(
            initialValue: Comment(content: "", author: commentsRepository.user),
            action: { [weak self] comment in
                try await self?.commentsRepository.create(comment)
                self?.comments.value?.insert(comment, at: 0)
            }
        )
    }
    
    
}


