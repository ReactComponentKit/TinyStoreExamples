//
//  ViewController.swift
//  CounterUIKit
//
//  Created by burt on 2022/04/14.
//

import UIKit
import TinyStore
import Combine

class ViewController: UIViewController {
    
    @IBOutlet weak var countLabel: UILabel!
    
    @UseState(name: AppStates.count)
    var count: Tiny.State<Int>
    var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        count.$value
            .receive(on: RunLoop.main)
            .sink { [weak self] value in
                self?.countLabel.text = "\(value)"
            }
            .store(in: &cancellables)
    }
    
    
    @IBAction func handleIncrement(_ sender: Any) {
        count.value += 1
    }
    
    @IBAction func handleDecrement(_ sender: Any) {
        count.value -= 1
    }
}

