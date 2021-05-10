//
//  CallViewController.swift
//  Calls
//
//  Created by Svetoslav Kanchev on 26.04.21.
//

import UIKit

class CallViewController: UIViewController {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet var hideButton: UIButton!
    @IBOutlet var endCallButton: UIButton!
    @IBOutlet var customKeypad: CustomKeypad!
    
    var name: String!
    var timer = Timer()
    var minutes = 0
    var seconds = 0
    var keypadInput = "" {
        didSet {
            nameLabel.text = keypadInput
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = name
        customKeypad.isHidden = true
        hideButton.setTitle("", for: .normal)
        customKeypad.buttons.forEach {
            $0.button.addTarget(self, action: #selector(buttonPressed), for: .touchDown)
            $0.backgroundColor = $0.backgroundColor?.withAlphaComponent(0.1)
            $0.titleLabel.textColor = .white
            $0.subtitleLabel.textColor = .white
        }
        runTimer()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        buttons.forEach {
            $0.layer.cornerRadius = $0.bounds.width * 0.5
            $0.clipsToBounds = true
        }
        endCallButton.layer.cornerRadius = endCallButton.bounds.width * 0.5
        endCallButton.clipsToBounds = true
    }
    
    @IBAction func endCall(_ sender: UIButton) {
        let contactStore = ContactStore.shared
        let name = contactStore.contactForNumber(number: nameLabel.text!) ?? nameLabel.text!
        let callStore = CallStore.shared
        callStore.createCall(name: name, phoneType: "mobile", date: Date(), isMissed: false, hasIcon: true)
        self.dismiss(animated: false, completion: nil)
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,
                selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        seconds += 1
        if seconds == 60 {
            seconds = 0
            minutes += 1
            if minutes == 60 {
                minutes = 0
            }
        }
        timeLabel.text = pad(minutes) + ":" + pad(seconds)
    }
    
    func pad(_ num: Int) -> String {
        return num > 9 ? "\(num)" : "0\(num)"
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        keypadInput.append(sender.currentTitle!)
        changeNumberBackgroundColor(customKeypad.buttons[sender.tag])
    }
    
    func changeNumberBackgroundColor(_ sender: UIView) {
        UIView.animate(withDuration: 1) {
            sender.backgroundColor = .systemGray3
            sender.backgroundColor = .systemGray5
        }
    }
    
    @IBAction func keypadButtonPressed(_ sender: UIButton) {
        UIView.transition(with: customKeypad, duration: 0.4,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.customKeypad.isHidden = false
                          })
        hideButton.setTitle("Hide", for: .normal)
        timeLabel.isHidden = true
        buttons.forEach {
            $0.isHidden = true
        }
    }
    
    @IBAction func hideButtonPressed(_ sender: UIButton) {
        UIView.transition(with: customKeypad, duration: 0.4,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.customKeypad.isHidden = true
                          })
        hideButton.setTitle("", for: .normal)
        nameLabel.text = name
        timeLabel.isHidden = false
        buttons.forEach {
            $0.isHidden = false
        }
    }
}
