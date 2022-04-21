//
//  AppStore.swift
//  UserListSwiftUI
//
//  Created by burt on 2022/04/16.
//

import Foundation
import TinyStore

struct AppStore {
    enum State {
        case userListAPI
        case postListAPI
        case postDetailAPI
        case postId
        case username
    }
    
    enum EffectValue {
        case userList
        case postList
        case postDetail
        case postListForUsername
    }
    
    init() {
        state(name: State.userListAPI, initialValue: UserListAPI())
        state(name: State.postListAPI, initialValue: PostListAPI())
        state(name: State.postDetailAPI, initialValue: PostDetailAPI())
        state(name: State.postId, initialValue: 0)
        state(name: State.username, initialValue: "")
        
        effectValue(name: EffectValue.userList, initialValue: [User]()) { effect in
            let api: UserListAPI = effect.watch(state: State.userListAPI)
            let userList = await api.fetchUserList()
            return userList
        }
        
        effectValue(name: EffectValue.postList, initialValue: [Post]()) { effect in
            let userList: [User] = effect.watch(effectValue: EffectValue.userList)
            let api: PostListAPI = effect.watch(state: State.postListAPI)
            let postList = await api.fetchPostList()
            return postList.map { it in
                var mutablePost = it
                let user = userList.first { user in
                    user.id == it.userId
                }
                mutablePost.userName = user?.name
                return mutablePost
            }
        }
        
        let _: Tiny.EffectValue<Post?> = effectValue(name: EffectValue.postDetail, initialValue: nil) { effect in
            let api: PostDetailAPI = effect.watch(state: State.postDetailAPI)
            let postId: Int = effect.watch(state: State.postId)
            let userList: Tiny.EffectValue<[User]> = useEffectValue(name: EffectValue.userList)
            var post = await api.fetchPostDetail(postId: postId)
            let userName = userList.value.filter { $0.id == post?.userId }.first?.name
            post?.userName = userName
            return post
        }
        
        effectValue(name: EffectValue.postListForUsername, initialValue: [Post]()) { effect in
            let username: String = effect.watch(state: AppStore.State.username)
            let postList: [Post] = effect.watch(effectValue: AppStore.EffectValue.postList)
            return postList.filter { $0.userName == username }
        }
    }
}
