//
//  FormViewModel.swift
//  twitterLike
//
//  Created by Антон Голубейков on 02.06.2022.
//

import Foundation

@MainActor
@dynamicMemberLookup
class FormViewModel<Value>: ObservableObject {
    typealias Action = (Value) async throws -> Void
 
    @Published var value: Value
    @Published var error: Error?
    
    //When we’re in the process of submitting the user’s credentials, we’ll use this property to let our views know
    @Published var isWorking = false
    
    //MARK: - generic Value type to specify the information collected and provide an action for submitting that information. Dynamic member lookup allows us to edit the value property by subscripting the FormViewModel directly.
    subscript<T>(dynamicMember keyPath: WritableKeyPath<Value, T>) -> T {
        get { value[keyPath: keyPath] }
        set { value[keyPath: keyPath] = newValue }
    }
 
    private let action: Action
 
    init(initialValue: Value, action: @escaping Action) {
        self.value = initialValue
        self.action = action
    }
    //MARK: - To submit the form in non-isolated way (not in main actor)
    nonisolated func submit() {
        Task {
            await handleSubmit()
        }
    }
    private func handleSubmit() async {
        isWorking = true
        do {
            try await action(value)
        } catch {
            print("[FormViewModel] Cannot submit: \(error)")
            self.error = error
        }
        isWorking = false
    }
    
}
