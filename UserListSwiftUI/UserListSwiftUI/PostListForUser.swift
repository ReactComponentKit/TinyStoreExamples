//
//  PostListForUser.swift
//  UserListSwiftUI
//
//  Created by burt on 2022/04/20.
//

import SwiftUI
import TinyStore

struct PostListForUser: View {
    
    @StateObject
    var username: Tiny.State<String> = useState(name: AppStore.State.username)
    
    @StateObject
    var postId: Tiny.State<Int> = useState(name: AppStore.State.postId)
    
    @StateObject
    var postList: Tiny.EffectValue<[Post]> = useEffectValue(name: AppStore.EffectValue.postListForUsername)
    
    @State
    var presentPostDetail: Bool = false
    
    var body: some View {
        VStack(spacing: 32) {
            Text(username.value)
                .font(.largeTitle)
            List(postList.value, id: \.id) { post in
                VStack(alignment: .leading, spacing: 8) {
                    Text(post.title)
                        .lineLimit(1)
                    Text(post.body)
                }
                .listRowSeparator(.hidden)
                .onTapGesture {
                    postId.value = post.id
                    presentPostDetail = true
                }
            }
            .listStyle(.plain)
            .sheet(isPresented: $presentPostDetail) {
                PostDetail()
            }
        }
        .padding()
    }
}
