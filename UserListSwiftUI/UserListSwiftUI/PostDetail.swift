//
//  PostDetail.swift
//  UserListSwiftUI
//
//  Created by burt on 2022/04/20.
//

import SwiftUI
import TinyStore

struct PostDetail: View {
    
    @StateObject
    var post: Tiny.EffectValue<Post?> = useEffectValue(name: AppStore.EffectValue.postDetail)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let postValue = post.value {
                Text(postValue.title)
                    .font(.title)
                Text(postValue.userName ?? "Unknown")
                    .font(.caption)
                Text(postValue.body)
                    .font(.body)
            } else {
                Text("No Post Data!")
                    .font(.subheadline)
            }
        }
        .padding()
    }
}

