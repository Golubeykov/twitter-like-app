//
//  Alert+Error.swift
//  twitterLike
//
//  Created by Антон Голубейков on 01.06.2022.
//

import SwiftUI

//This defines an alert(_:error:) modifier, which makes the ErrorAlertViewModifier accessible to the rest of our application.
extension View {
    func alert(_ title: String, error: Binding<Error?>) -> some View {
        modifier(ErrorAlertViewModifier(title: title, error: error))
    }
}
//This defines a view modifier that shows an alert when the provided error binding is set to a non-nil value
private struct ErrorAlertViewModifier: ViewModifier {
    let title: String
    @Binding var error: Error?
    
    func body(content: Content) -> some View {
        content
            .alert(title, isPresented: $error.hasValue, presenting: error, actions: { _ in }) { error in
                Text(error.localizedDescription)
            }
    }
}

private extension Optional {
    var hasValue: Bool {
        get { self != nil }
        set { self = newValue ? self : nil }
    }
}

struct ErrorAlertViewModifier_Previews: PreviewProvider {
    static var previews: some View {
        Text("Preview")
            .alert("Error", error: .constant(PreviewError()))
    }
    
    private struct PreviewError: LocalizedError {
        let errorDescription: String? = "Lorem ipsum dolor set amet."
    }
}
