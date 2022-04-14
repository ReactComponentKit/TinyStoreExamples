//
//  ContentView.swift
//  CountSwiftUI
//
//  Created by burt on 2022/04/14.
//

import SwiftUI
import TinyStore

struct ContentView: View {
    
    @StateObject
    var count: Tiny.State<Int> = useState(name: AppStates.count)
    
    var body: some View {
        VStack {
            Spacer()
            Text("\(count.value)")
                .padding()
            Spacer()
            HStack {
                Spacer()
                Button(action: { count.value -= 1 }) {
                    Text("Decrement")
                }
                Spacer()
                Button(action: { count.value += 1 }) {
                    Text("Increment")
                }
                Spacer()
            }
            Spacer()
        }
        .font(.title2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
