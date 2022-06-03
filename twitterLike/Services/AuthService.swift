//
//  AuthService.swift
//  twitterLike
//
//  Created by Антон Голубейков on 02.06.2022.
//

import FirebaseAuth

@MainActor
class AuthService: ObservableObject {
    @Published var user: User?
    
    private let auth = Auth.auth()
    private var listener: AuthStateDidChangeListenerHandle?
    
    //This converts the user parameter passed to the state change listener into a User type and assigns it to the user property of the AuthService
    init() {
            listener = auth.addStateDidChangeListener { [weak self] _, user in
                self?.user = user.map(User.init(from:))
            }
        }
    
    func createAccount(name: String, email: String, password: String) async throws {
        let result = try await auth.createUser(withEmail: email, password: password)
        self.user?.name = name
        try await result.user.updateProfile(\.displayName, to: name)
    }
    
    func signIn(email: String, password: String) async throws {
        try await auth.signIn(withEmail: email, password: password)
    }
    
    func signOut() throws {
        try auth.signOut()
    }
}
//MARK: - Update user profile
private extension FirebaseAuth.User {
    func updateProfile<T>(_ keyPath: WritableKeyPath<UserProfileChangeRequest, T>, to newValue: T) async throws {
        var profileChangeRequest = createProfileChangeRequest()
        profileChangeRequest[keyPath: keyPath] = newValue
        try await profileChangeRequest.commitChanges()
    }
}
//MARK: - Here we convert FirebaseAuth.User object into User model
private extension User {
    init(from firebaseUser: FirebaseAuth.User) {
        self.id = firebaseUser.uid
        self.name = firebaseUser.displayName ?? ""
    }
}
