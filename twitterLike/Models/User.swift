//
//  User.swift
//  twitterLike
//
//  Created by Антон Голубейков on 03.06.2022.
//

import Foundation

struct User: Identifiable, Equatable, Codable {
    var id: String
    var name: String
}

extension User {
    static let testUser = User(id: "", name: "Jamie Harris")
}
