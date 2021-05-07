//
//  CustomKeypad.swift
//  Calls
//
//  Created by Svetlio on 4.05.21.
//

import UIKit

class CustomKeypad: UIControl {
    private let keypadCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize.width = 120
        layout.itemSize.height = 120
        layout.minimumInteritemSpacing = 15
        layout.minimumLineSpacing = 25
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 100, height: 300), collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .white
        return collection
    }()
    
    let keypadDataSource = CustomKeypadDataSource()
    
    var buttons: [CustomButton] = [] {
        didSet {
            keypadDataSource.buttons = buttons
        }
    }
    
//    private let verticalStackView: UIStackView = {
//        let stackView = UIStackView()
//
//        stackView.axis = .vertical
//        stackView.distribution = .fillEqually
//        //stackView.alignment = .center
//        stackView.spacing = 15
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//
//        return stackView
//    }()
//
//    private let horizontalStackView: UIStackView = {
//        let stackView = UIStackView()
//
//        stackView.axis = .horizontal
//        stackView.distribution = .fillEqually
//        //stackView.alignment = .center
//        stackView.spacing = 25
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//
//        return stackView
//    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViewHierarchy()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViewHierarchy()
    }
    
    func configureViewHierarchy() {
        addSubview(keypadCollection)
        NSLayoutConstraint.activate([
            keypadCollection.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            keypadCollection.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 30),
            keypadCollection.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 20)
        ])
        keypadCollection.dataSource = keypadDataSource
//        addSubview(verticalStackView)
//        for _ in 1...5 {
//            verticalStackView.addArrangedSubview(horizontalStackView)
//        }
//
//        NSLayoutConstraint.activate([
//            verticalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
//            verticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 30),
//            verticalStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 20),
//        ])
    }
    
    func addButton(_ button: CustomButton) {
        buttons.append(button)
    }
}

class CustomButton: UIView {
    private let button: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .clear
        return btn
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font.withSize(40)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font.withSize(12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func layoutSubviews() {
        layer.cornerRadius = bounds.width * 0.5
        clipsToBounds = true
    }
    
    func setView(_ params: (title: String, subtitle: String, image: UIImage?)) {
        titleLabel.text = params.title
        subtitleLabel.text = params.subtitle
        if let image = params.image {
            button.setImage(image, for: .normal)
            //button.imageView?.preferredSymbolConfiguration.
            button.backgroundColor = .systemGreen
        }
        setConstraints()
    }
    
    func setConstraints() {
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(button)
        backgroundColor = .systemGray5
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -10),
            titleLabel.bottomAnchor.constraint(equalTo: subtitleLabel.topAnchor),
            subtitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.topAnchor.constraint(equalTo: topAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
