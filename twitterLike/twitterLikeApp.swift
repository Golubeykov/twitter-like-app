//
//  twitterLikeApp.swift
//  twitterLike
//
//  Created by Антон Голубейков on 30.05.2022.
//

import SwiftUI
import Firebase

@main
struct twitterLikeApp: App {
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            PostsList()
        }
    }
}
