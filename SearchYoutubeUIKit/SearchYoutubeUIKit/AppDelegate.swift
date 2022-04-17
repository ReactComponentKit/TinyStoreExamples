//
//  AppDelegate.swift
//  SearchYoutubeUIKit
//
//  Created by burt on 2022/04/16.
//

import UIKit
import TinyStore
import Combine

@propertyWrapper struct TState<Value: Equatable>: Equatable {
    internal var value: Value
    init(value: Value) {
        self.value = value
    }
    
    var wrappedValue: Value {
        get {
            return value
        }
        set {
            value = newValue
        }
    }
}

@propertyWrapper class TWatch<Value: Equatable>: ObservableObject {
    @Published
    internal var value: Value
    
    init(value: Value) {
        self.value = value
    }
    
    var wrappedValue: Published<Value>.Publisher {
        return $value
    }
}

@propertyWrapper struct UseState<Value: Equatable> {
    private var state: Tiny.State<Value>
    init(name: AnyHashable) {
        self.state = useState(name: name)
    }
    
    var wrappedValue: Tiny.State<Value> {
        return state
    }
}

@propertyWrapper struct UseEffectValue<Value: Equatable> {
    private var effect: Tiny.Effect<Value>
    
    init(name: AnyHashable) {
        self.effect = useEffect(name: name)
    }
    
    var wrappedValue: Tiny.Effect<Value> {
        return effect
    }
}

@propertyWrapper struct UseEffect {
    private var effect: Tiny.VoidEffect
    
    init(name: AnyHashable) {
        self.effect = useEffect(name: name)
    }
    
    var wrappedValue: Tiny.VoidEffect {
        return effect
    }
}

struct Test {
    @TState(value: 10)
    var age
    
    @TWatch(value: TState(value: "Hello"))
    var name
    
    func test() {

    }
}

struct IsFirstAppLaunch: Equatable {
    private enum Key: String {
        case isFirstAppLaunch
    }
    var value: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Key.isFirstAppLaunch.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.isFirstAppLaunch.rawValue)
        }
    }
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.value == rhs.value
    }
}


struct MyAppState {
    enum Store {
        case store
    }

    enum State {
        case isFirstAppLaunch
    }

    enum Effect {
        case get
        case test
    }

    init() {
        let myStore = store(name: Store.store)
        state(name: State.isFirstAppLaunch, initialValue: IsFirstAppLaunch(), store: myStore)

        effect(name: Effect.get, initialValue: false, store: myStore) { effect in
            let store = useStore(name: Store.store)
            let isFirstState: Tiny.State<IsFirstAppLaunch> = effect.watch(state: State.isFirstAppLaunch, store: store)
            return isFirstState.value.value
        }
        
        effect(name: Effect.test, store: myStore) { effect in
            let store = useStore(name: Store.store)
            let isFirstState: Tiny.State<IsFirstAppLaunch> = effect.watch(state: State.isFirstAppLaunch, store: store)
            print("여기서", isFirstState.value.value)
        }
    }
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    @Tiny.AppState(key: "name", defaultValue: "Hello")
    var name: Tiny.State<String>
    let appState = MyAppState()
    let getEffect: Tiny.Effect<Bool> = useEffect(name: MyAppState.Effect.get)
    var cancellable = Set<AnyCancellable>()
    
    @UseState(name: MyAppState.State.isFirstAppLaunch)
    var isFirstAppLaunch: Tiny.State<IsFirstAppLaunch>
    
    @UseEffectValue(name: MyAppState.Effect.get)
    var effectValue: Tiny.Effect<Bool>
    
    @UseEffect(name: MyAppState.Effect.test)
    var testEffect: Tiny.VoidEffect
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        getEffect.$value
            .receive(on: RunLoop.main)
            .sink { value in
                print("1", value)
            }
            .store(in: &cancellable)
        
        
        effectValue.$value
            .receive(on: RunLoop.main)
            .sink { value in
                print("2", value)
            }
            .store(in: &cancellable)
        
        
        let isFirstState: Tiny.State<IsFirstAppLaunch> = useState(name: MyAppState.State.isFirstAppLaunch)
        isFirstState.value.value = true
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

