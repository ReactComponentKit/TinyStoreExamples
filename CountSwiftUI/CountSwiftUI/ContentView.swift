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
            Stepper(value: $count.value) {
            }
            .labelsHidden()
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
