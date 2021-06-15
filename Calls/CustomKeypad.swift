//
//  CustomKeypad.swift
//  Calls
//
//  Created by Svetlio on 4.05.21.
//

import UIKit

enum KeypadStyles {
    case dial, call, none
}

class CustomKeypad: UIControl, UICollectionViewDataSource {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //configureViewHierarchy()
    }
    
    var buttonBackgroundColor: UIColor = .systemGray5
    var titleColor: UIColor = .black
    var subtitleColor: UIColor = .black
    
    var buttons: [CustomButton] = []
    var style: KeypadStyles = .none {
        didSet {
            if style == .dial {
                buttonBackgroundColor = .systemGray5
                titleColor = .black
                subtitleColor = .black
                configureViewHierarchy()
                let zeroButtonIndex = buttons.firstIndex { $0.titleLabel.text == "0" }!
                let zeroButton = buttons[zeroButtonIndex]
                let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressZero))
                zeroButton.button.addGestureRecognizer(gestureRecognizer)
                
            } else if style == .call {
                buttonBackgroundColor = backgroundColor!.withAlphaComponent(0.1)
                titleColor = .white
                subtitleColor = .white
                configureViewHierarchy()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        buttons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath)
        cell.backgroundView = buttons[indexPath.row]
        return cell
    }
    
    var keyPressed = ""
    var buttonTag = 0
    
    @objc func buttonPressed(_ sender: UIButton){
        keyPressed = sender.currentTitle!
        buttonTag = sender.tag
        sendActions(for: .valueChanged)
    }
    
    func configureViewHierarchy() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: frame.width / 3 - 30, height: frame.width / 3 - 30)
        layout.minimumInteritemSpacing = 12.5
        layout.minimumLineSpacing = 15
        
        let keypadCollection = UICollectionView(frame: frame, collectionViewLayout: layout)
        keypadCollection.translatesAutoresizingMaskIntoConstraints = false
        keypadCollection.backgroundColor = .clear
        keypadCollection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
        
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
        
        var tag = 0
        buttons = viewLabels.map {
            let customButton = CustomButton()
            customButton.setView($0,tag,buttonBackgroundColor,titleColor,subtitleColor)
            tag += 1
            customButton.button.addTarget(self, action: #selector(buttonPressed), for: .touchDown)
            return customButton
        }
    }
    
    var plusPressed = false
    
    @objc func longPressZero(_ sender: UIButton) {
        plusPressed.toggle()
        if plusPressed {
            keyPressed = "+"
            sendActions(for: .valueChanged)
//            numberLabel.text?.append("+")
//            if numberLabel.text!.count == 1 {
//                addNumberButton.isHidden = false
//                deleteButton.isHidden = false
//            }
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
    
    func setView(_ params: (title: String, subtitle: String),_ tag: Int,_ backgroundColor: UIColor,_ titleColor: UIColor,_ subtitleColor: UIColor) {
        titleLabel.text = params.title
        subtitleLabel.text = params.subtitle
        button.setTitle(params.title, for: .normal)
        button.setTitleColor(.clear, for: .normal)
        button.tag = tag
        setConstraints(backgroundColor: backgroundColor, titleColor: titleColor, subtitleColor: subtitleColor)
    }
    
    func setConstraints(backgroundColor: UIColor, titleColor: UIColor, subtitleColor: UIColor) {
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(button)
        self.backgroundColor = backgroundColor
        
        titleLabel.font = UIFont.systemFont(ofSize: 40)
        titleLabel.textColor = titleColor
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        subtitleLabel.font = UIFont.systemFont(ofSize: 12)
        subtitleLabel.textColor = subtitleColor
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
