//
//  CommentsList.swift
//  twitterLike
//
//  Created by Антон Голубейков on 04.06.2022.
//

import SwiftUI

struct CommentsList: View {
    @StateObject var viewModel: CommentsViewModel
 
    var body: some View {
        Group {
            switch viewModel.comments {
            case .loading:
                ProgressView()
                    .onAppear {
                        viewModel.fetchComments()
                    }
            case let .error(error):
                EmptyListView(
                    title: "Cannot Load Comments",
                    message: error.localizedDescription,
                    retryAction: {
                        viewModel.fetchComments()
                    }
                )
            case .empty:
                EmptyListView(
                    title: "No Comments",
                    message: "Be the first to leave a comment."
                )
            case let .loaded(comments):
                List(comments) { comment in
                    CommentRow(comment: comment)
                }
                .animation(.default, value: comments)
            }
        }
        .navigationTitle("Comments")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#if DEBUG
struct CommentsList_Previews: PreviewProvider {
    static var previews: some View {
        ListPreview(state: .loaded([Comment.testComment]))
        ListPreview(state: .empty)
        ListPreview(state: .error)
        ListPreview(state: .loading)
    }
 
    private struct ListPreview: View {
        let state: Loadable<[Comment]>
 
        var body: some View {
            NavigationView {
                CommentsList(viewModel: CommentsViewModel(commentsRepository: CommentsRepositoryStub(state: state)))
            }
        }
    }
}
#endif
