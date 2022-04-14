//
//  AppStates.swift
//  GetWebSiteUIKit
//
//  Created by burt on 2022/04/14.
//

import Foundation
import TinyStore

enum AppState {
    case url
    case content
}

enum AppEffect {
    case fetchSite
}

func defineAppStates() {
    state(name: AppState.url, initialValue: "")
    state(name: AppState.content, initialValue: Async<String>.idle)
}

func defineAppEffects() {
    effect(name: AppEffect.fetchSite) { effect in
        let urlString: Tiny.State<String> = effect.watch(state: AppState.url)
        let content: Tiny.State<Async<String>> = useState(name: AppState.content)

        guard let url = URL(string: urlString.value) else { return }
        do {
            content.commit { $0 = .loading }
            let (data, _) = try await URLSession.shared.data(from: url)
            content.commit { $0 = .value(value: String(data: data, encoding: .utf8) ?? "") }
        } catch {
            content.commit { $0 = .error(value: error) }
        }
    }
}
