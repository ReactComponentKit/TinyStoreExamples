//
//  ContentView.swift
//  UserListSwiftUI
//
//  Created by burt on 2022/04/17.
//

import SwiftUI
import TinyStore

struct ContentView: View {
    @StateObject
    var userList: Tiny.EffectValue<[User]> = useEffectValue(name: AppStore.EffectValue.userList)
    
    @StateObject
    var postList: Tiny.EffectValue<[Post]> = useEffectValue(name: AppStore.EffectValue.postList)
    
    @StateObject
    var postId: Tiny.State<Int> = useState(name: AppStore.State.postId)
    
    @StateObject
    var username: Tiny.State<String> = useState(name: AppStore.State.username)
    
    @State
    var listType = "user"
    
    @State
    var presentPostDetail: Bool = false
    
    @State
    var presentPostListForUser: Bool = false
    
    var body: some View {
        VStack {
            Picker("", selection: $listType) {
                Text("User").tag("user")
                Text("Post").tag("post")
            }
            .pickerStyle(.segmented)
            .padding()
                
            if listType == "user" {
                List(userList.value, id: \.id) { user in
                    Text(user.name)
                        .listRowSeparator(.hidden)
                        .onTapGesture {
                            username.value = user.name
                            presentPostListForUser = true
                        }
                }
                .listStyle(.plain)
                .sheet(isPresented: $presentPostListForUser) {
                    PostListForUser()
                }
            } else {
                List(postList.value, id: \.id) { post in
                    VStack(alignment: .leading) {
                        Text(post.title)
                            .lineLimit(1)
                        Text(post.body)
                        Text(post.userName ?? "Unknown")
                            .frame(maxWidth: .infinity, alignment: .trailing)
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
            Spacer()
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
