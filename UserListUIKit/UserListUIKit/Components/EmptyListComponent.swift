//
//  EmptyListComponent.swift
//  UserListUIKit
//
//  Created by burt on 2022/04/17.
//

import UIKit
import SnapKit
import ListKit

struct EmptyListComponent: Component {
    
    typealias Content = EmptyListComponentContentView
    
    var id: AnyHashable = UUID()
    let title: String
    
    init(title: String) {
        self.title = title
    }
    
    func contentView() -> EmptyListComponentContentView {
        return EmptyListComponentContentView()
    }
    
    func layoutSize() -> NSCollectionLayoutSize {
        return NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.8))
    }
    
    func render(in content: EmptyListComponentContentView) {
        content.label.text = title
    }
}


final class EmptyListComponentContentView: UIView {
    
    lazy var label: UILabel = {
        let label = UILabel(frame: .zero)
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setupViews() {
        self.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
