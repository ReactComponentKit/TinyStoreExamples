//
//  WebViewController.swift
//  GetWebSiteUIKit
//
//  Created by burt on 2022/04/14.
//

import UIKit
import WebKit
import TinyStore

class WebViewController: UIViewController {
    
    static func new() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "WebViewController")
        return vc
    }
    
    @IBOutlet weak var webView: WKWebView!
    
    let url: Tiny.State<String> = useState(name: AppState.url)
    let content: Tiny.State<Async<String>> = useState(name: AppState.content)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if case let .value(value: html) = content.value, let url = URL(string: url.value) {
            webView.loadHTMLString(html, baseURL: url)
        }
    }
}
