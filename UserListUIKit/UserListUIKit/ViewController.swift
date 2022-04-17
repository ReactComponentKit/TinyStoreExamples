//
//  ViewController.swift
//  UserListUIKit
//
//  Created by burt on 2022/04/16.
//

import UIKit
import TinyStore
import Combine
import ListKit

class ViewController: UIViewController {
    
    @UseEffectValue(name: AppStore.EffectValue.userList)
    var userList: Tiny.EffectValue<[User]>
    
    @UseEffectValue(name: AppStore.EffectValue.postList)
    var postList: Tiny.EffectValue<[Post]>
    
    var cancellables = Set<AnyCancellable>()
    
    @IBOutlet weak var userListCollectionView: UICollectionView!
    @IBOutlet weak var postListCollectionView: UICollectionView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    private enum Sections {
        case userList
        case postList
    }
    
    private var userListRenderer = ComposeRenderer(dataSource: DiffableDataSource())
    private var postListRenderer = ComposeRenderer(dataSource: DiffableDataSource())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userListRenderer.target = userListCollectionView
        postListRenderer.target = postListCollectionView
        
        userList
            .$value
            .receive(on: RunLoop.main)
            .sink { [weak self] value in
                self?.render()
            }
            .store(in: &cancellables)
        
        postList
            .$value
            .receive(on: RunLoop.main)
            .sink { [weak self] value in
                self?.render()
            }
            .store(in: &cancellables)
    }
    
    private func render() {
        if segmentedControl.selectedSegmentIndex == 0 {
            renderUserList()
        } else {
            renderPostList()
        }
    }
    
    private func renderUserList() {
        postListCollectionView.isHidden = true
        userListCollectionView.isHidden = false
        userListRenderer.render(animated: false) {
            Section(id: Sections.userList) {
                if userList.value.isEmpty {
                    VGroup(width: .fractionalWidth(1.0), height: .fractionalHeight(1.0)) {
                        EmptyListComponent(title: "No Users")
                    }
                } else {
                    VGroup(of: userList.value, width: .fractionalWidth(1.0), height: .estimated(30)) { user in
                        UserComponent(user: user)
                    }
                }
            }
            .contentInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
        }
    }
    
    private func renderPostList() {
        postListCollectionView.isHidden = false
        userListCollectionView.isHidden = true
        postListRenderer.render(animated: false) {
            Section(id: Sections.postList) {
                if userList.value.isEmpty {
                    VGroup(width: .fractionalWidth(1.0), height: .fractionalHeight(1.0)) {
                        EmptyListComponent(title: "No Posts")
                    }
                } else {
                    VGroup(of: postList.value, width: .fractionalWidth(1.0), height: .estimated(30)) { post in
                        PostComponent(post: post) { item in
                            print(item)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func handleChangeSegmentIndex(_ sender: UISegmentedControl) {
        render()
    }
}
