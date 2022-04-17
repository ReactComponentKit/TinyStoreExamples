//
//  UserComponent.swift
//  UserListUIKit
//
//  Created by burt on 2022/04/16.
//

import UIKit
import SnapKit
import ListKit

struct UserComponent: Component {
    typealias Content = UserComponentContentView
    
    let user: User
    
    var id: AnyHashable {
        user.id
    }
        
    init(user: User) {
        self.user = user
    }
    
    func contentView() -> UserComponentContentView {
        return UserComponentContentView()
    }
    
    func layoutSize() -> NSCollectionLayoutSize {
        return NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150))
    }
    
    func edgeSpacing() -> NSCollectionLayoutEdgeSpacing? {
        return .init(leading: nil, top: nil, trailing: nil, bottom: .fixed(8.0))
    }
    
    func render(in content: UserComponentContentView) {
        content.nameLabel.text = user.name
        content.emailLabel.text = "📧 \(user.email)"
        content.websiteLabel.text = "🌏 \(user.website)"
    }
}


final class UserComponentContentView: UIView {
    
    lazy var nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    lazy var emailLabel: UILabel = {
        let label = UILabel(frame: .zero)
        return label
    }()
    
    lazy var websiteLabel: UILabel = {
        let label = UILabel(frame: .zero)
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [self.nameLabel, self.emailLabel, self.websiteLabel])
        stack.axis = .vertical
        stack.alignment = .top
        stack.spacing = 8
        return stack
    }()
    
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
    }
}
