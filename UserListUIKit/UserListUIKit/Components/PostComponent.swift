//
//  PostComponent.swift
//  UserListUIKit
//
//  Created by burt on 2022/04/16.
//

import UIKit
import SnapKit
import ListKit

struct PostComponent: Component {
    typealias Content = PostComponentContentView
    
    let post: Post
    
    var id: AnyHashable {
        post.id
    }
    
    var onClickPost: ((Post) -> Void)?
    
    init(post: Post, onClickPost: @escaping (Post) -> Void) {
        self.post = post
        self.onClickPost = onClickPost
    }
    
    func contentView() -> PostComponentContentView {
        return PostComponentContentView()
    }
    
    func layoutSize() -> NSCollectionLayoutSize {
        return NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(30))
    }
    
    func edgeSpacing() -> NSCollectionLayoutEdgeSpacing? {
        return .init(leading: nil, top: nil, trailing: nil, bottom: .fixed(8.0))
    }
    
    func render(in content: PostComponentContentView) {
        content.titleLabel.text = post.title
        content.contentLabel.text = post.body
        content.userName.text = post.userName
        content.onClickContentView = {
            onClickPost?(post)
        }
    }
}


final class PostComponentContentView: UIView {
    
    private lazy var textColor: UIColor = UIColor.black
    private lazy var userNameColor: UIColor = UIColor.lightGray
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = self.textColor
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    lazy var contentLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = -1
        label.textColor = self.textColor
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var userName: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 8)
        label.textColor = self.userNameColor
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [self.titleLabel, self.contentLabel, self.userName])
        stack.axis = .vertical
        stack.alignment = .top
        stack.spacing = 16
        return stack
    }()
    
    lazy var tapGesture: UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
    }()
    
    var onClickContentView: (() -> Void)?
    
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setupViews() {
        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        userName.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        
        self.addGestureRecognizer(self.tapGesture)
    }
    
    @objc
    func handleTapGesture(_ tap: UITapGestureRecognizer) {
        onClickContentView?()
    }
}
