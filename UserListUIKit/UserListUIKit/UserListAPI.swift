//
//  UserListAPI.swift
//  UserListSwiftUI
//
//  Created by burt on 2022/04/16.
//

import Foundation

struct User: Equatable, Codable {
    let id: Int
    let name: String
    let website: String
    let email: String
}

struct UserListAPI: Equatable {
    func fetchUserList() async -> [User] {
        do {
            let (data, _) = try await URLSession.shared.data(from: URL(string: "https://jsonplaceholder.typicode.com/users/")!)
            let users = try JSONDecoder().decode([User].self, from: data)
            return users
        } catch {
            return []
        }
    }
}
