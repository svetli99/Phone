//
//  CustomKeypad.swift
//  Calls
//
//  Created by Svetlio on 4.05.21.
//

import UIKit

class CustomKeypad: UIControl, UICollectionViewDataSource {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViewHierarchy()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViewHierarchy()
    }
    
    var buttons: [CustomButton] = []
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(buttons.count, section)
        return buttons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath)
        cell.backgroundView = buttons[indexPath.row]
        print(indexPath.row)
        return cell
    }
    
    func configureViewHierarchy() {
        let keypadCollection: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: frame.width / 3 - 30, height: frame.width / 3 - 30)
//            layout.itemSize.width = 70
//            layout.itemSize.height = 70
            layout.minimumInteritemSpacing = 12.5
            layout.minimumLineSpacing = 15
            //layout.estimatedItemSize = .zero
            print(frame)
            let collection = UICollectionView(frame: frame, collectionViewLayout: layout)
            collection.translatesAutoresizingMaskIntoConstraints = false
            collection.backgroundColor = .clear
            collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
            return collection
        }()
        
        addSubview(keypadCollection)
        NSLayoutConstraint.activate([
            keypadCollection.topAnchor.constraint(equalTo: topAnchor),
            keypadCollection.leadingAnchor.constraint(equalTo: leadingAnchor),
            keypadCollection.trailingAnchor.constraint(equalTo: trailingAnchor),
            keypadCollection.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        keypadCollection.dataSource = self
        
        let viewLabels = [
            ("1",""),
            ("2","A B C"),
            ("3","D E F"),
            ("4","G H I"),
            ("5","J K L"),
            ("6","M N O"),
            ("7","P Q R S"),
            ("8","T U V"),
            ("9","W X Y Z"),
            ("*",""),
            ("0","+"),
            ("#","")
        ]
        
        buttons = viewLabels.map {
            let button = CustomButton()
            button.setView($0)
            return button
        }
    }
}

class CustomButton: UIView {
    let button: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .clear
        return btn
    }()
    
    var titleLabel = UILabel()
    var subtitleLabel = UILabel()
    
    override func layoutSubviews() {
        layer.cornerRadius = bounds.width * 0.5
        clipsToBounds = true
    }
    
    func setView(_ params: (title: String, subtitle: String)) {
        titleLabel.text = params.title
        subtitleLabel.text = params.subtitle
        button.setTitle(params.title, for: .normal)
        setConstraints()
    }
    
    func setConstraints() {
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(button)
        bringSubviewToFront(button)
        backgroundColor = .systemGray5
        
        titleLabel.font = UIFont.systemFont(ofSize: 40)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        subtitleLabel.font = UIFont.systemFont(ofSize: 12)
        subtitleLabel.textColor = .white
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: subtitleLabel.text == "" ? 0 : -10),
            titleLabel.bottomAnchor.constraint(equalTo: subtitleLabel.topAnchor),
            subtitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.topAnchor.constraint(equalTo: topAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
    }
}
