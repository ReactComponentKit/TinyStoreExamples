//
//  AppStore.swift
//  UserListUIKit
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
    }
    
    enum EffectValue {
        case userList
        case postList
        case postDetail
    }
    
    init() {
        state(name: State.userListAPI, initialValue: UserListAPI())
        state(name: State.postListAPI, initialValue: PostListAPI())
        state(name: State.postDetailAPI, initialValue: PostDetailAPI())
        state(name: State.postId, initialValue: 0)
        
        effectValue(name: EffectValue.userList, initialValue: [User]()) { effect in
            let api: Tiny.State<UserListAPI> = effect.watch(state: State.userListAPI)
            let userList = await api.value.fetchUserList()
            return userList
        }
        
        effectValue(name: EffectValue.postList, initialValue: [Post]()) { effect in
            let userList: Tiny.EffectValue<[User]> = effect.watch(effectValue: EffectValue.userList)
            let api: Tiny.State<PostListAPI> = effect.watch(state: State.postListAPI)
            let postList = await api.value.fetchPostList()
            return postList.map { it in
                var mutablePost = it
                let user = userList.value.first { user in
                    user.id == it.userId
                }
                mutablePost.userName = user?.name
                return mutablePost
            }
        }
        
        let _: Tiny.EffectValue<Post?> = effectValue(name: EffectValue.postDetail, initialValue: nil) { effect in
            let api: Tiny.State<PostDetailAPI> = effect.watch(state: State.postDetailAPI)
            let postId: Tiny.State<Int> = effect.watch(state: State.postId)
            let post = await api.value.fetchPostDetail(postId: postId.value)
            return post
        }
    }
}
