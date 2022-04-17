//
//  AppStore.swift
//  SearchYoutubeUIKit
//
//  Created by burt on 2022/04/16.
//

import Foundation
import Combine
import TinyStore

//class SmallStore: ObservableObject {
//    @Published
//    public var value: Bool
//
//    init(value: Bool) {
//
//
//    }
//
//    func getter() -> Bool {
//        return value
//    }
//
//    func setter(newValue: Bool) {
//        value = newValue
//        setEffect()
//    }
//
//    func setEffect() {
//        UserDefaults.standard.set(value, forKey: "MyValue")
//    }
//
//    func initEffect() {
//        let v = UserDefaults.standard.bool(forKey: "MyValue")
//        self.value = v
//    }
//}
//
//// set effect
///

@propertyWrapper
struct TwelveOrLess {
    private var number: Int
    init() { self.number = 0 }
    
    var wrappedValue: Int {
        get { return number }
        set { number = min(newValue, 12) }
    }
}

struct SmallRectangle {
    @TwelveOrLess
    var height: Int
    @TwelveOrLess
    var width: Int
}

@propertyWrapper
struct UserDefault<T> {
    private let key: String
    private let defaultValue: T
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

struct User {
    @UserDefault(key: "name", defaultValue: "Hello")
    static var myName: String
}

extension Tiny {
@propertyWrapper
struct AppState<Value: Equatable> {
    private let key: AnyHashable
    private var state: Tiny.State<Value>
    
    init(key: AnyHashable, defaultValue: Value, store: Tiny.ScopeStore = Tiny.globalStore) {
        self.key = key
        self.state = TinyStore.state(name: key, initialValue: defaultValue, store: store)
    }
    
    var wrappedValue: Tiny.State<Value> {
        get {
            return state
        }
    }
    
    var rawValue: Value {
        return state.value
    }
}
}
