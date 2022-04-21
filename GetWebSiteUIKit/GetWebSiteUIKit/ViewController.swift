//
//  ViewController.swift
//  GetWebSiteUIKit
//
//  Created by burt on 2022/04/14.
//

import UIKit
import Combine
import TinyStore

class ViewController: UIViewController {
    @UseState(name: AppState.content)
    var content: Tiny.State<Async<String>>
    @UseState(name: AppState.url)
    var url: Tiny.State<String>
    @UseEffect(name: AppEffect.fetchSite)
    var effect: Tiny.Effect
    var cancellables = Set<AnyCancellable>()
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        content.$value
            .receive(on: RunLoop.main)
            .sink { [weak self] value in
                switch value {
                case .idle:
                    self?.loadingIndicator.isHidden = true
                case .loading:
                    self?.loadingIndicator.isHidden = false
                case .value(let value):
                    self?.loadingIndicator.isHidden = true
                    self?.textView.text = value
                case .error(let value):
                    self?.loadingIndicator.isHidden = true
                    self?.textView.text = value?.localizedDescription
                }
            }
            .store(in: &cancellables)
    }


    @IBAction
    func handleGetWebsiteHtml(_ sender: UIButton) {
        guard let text = textField.text else { return }
        if text.isEmpty {
            let alert = UIAlertController(title: "Alert", message: "URL is empty!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alert, animated: true)
            return
        }
        url.value = text
    }
    
    @IBAction
    func handlerRenderHTML(_ sender: UIButton) {
        let vc = WebViewController.new()
        self.present(vc, animated: true)
    }
}

