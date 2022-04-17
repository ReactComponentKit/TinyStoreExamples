//
//  ViewController.swift
//  SearchYoutubeUIKit
//
//  Created by burt on 2022/04/16.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}


extension ViewController: UISearchBarDelegate {
    
}
