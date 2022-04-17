//
//  PostListAPI.swift
//  UserListUIKit
//
//  Created by burt on 2022/04/16.
//

import Foundation

struct Post: Equatable, Codable {
    let userId: Int
    let id: Int
    var userName: String?
    let title: String
    let body: String
}

struct PostListAPI: Equatable {
    func fetchPostList() async -> [Post] {
        do {
            let (data, _) = try await URLSession.shared.data(from: URL(string: "https://jsonplaceholder.typicode.com/posts")!)
            let posts = try JSONDecoder().decode([Post].self, from: data)
            return posts
        } catch {
            return []
        }
    }
}

struct PostDetailAPI: Equatable {
    func fetchPostDetail(postId: Int) async -> Post? {
        do {
            let (data, _) = try await URLSession.shared.data(from: URL(string: "https://jsonplaceholder.typicode.com/posts/\(postId)/")!)
            let post = try JSONDecoder().decode(Post.self, from: data)
            return post
        } catch {
            return nil
        }
    }
}
