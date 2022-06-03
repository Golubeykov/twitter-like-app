//
//  AuthViewModel.swift
//  twitterLike
//
//  Created by Антон Голубейков on 02.06.2022.
//

import Foundation

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    
    private let authService = AuthService()
 
    init() {
        authService.$isAuthenticated.assign(to: &$isAuthenticated)
    }
    
    //MARK: - initilizing SignIn/CreateAccountViewModels (see below)
    func makeSignInViewModel() -> SignInViewModel {
        return SignInViewModel(action: authService.signIn(email:password:))
    }
     
    func makeCreateAccountViewModel() -> CreateAccountViewModel {
        return CreateAccountViewModel(action: authService.createAccount(name:email:password:))
    }
}
//MARK: - this is where we’ll subclass the FormViewModel for use in the SignInForm and CreateAccountForm. Here, we defined the SignInViewModel, which collects an email and password, and the CreateAccountViewModel, which collects a name, email, and password. We can use the FormViewModel without subclassing, but by creating these as subclasses, we’ve streamlined our call sites by specifying the Value type and initialValue parameter in one place.
extension AuthViewModel {
    class SignInViewModel: FormViewModel<(email: String, password: String)> {
        convenience init(action: @escaping Action) {
            self.init(initialValue: (email: "", password: ""), action: action)
        }
    }
 
    class CreateAccountViewModel: FormViewModel<(name: String, email: String, password: String)> {
        convenience init(action: @escaping Action) {
            self.init(initialValue: (name: "", email: "", password: ""), action: action)
        }
    }
}
