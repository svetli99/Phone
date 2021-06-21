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
    var type: String!
    var number: String!
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
        customKeypad.addTarget(self, action: #selector(buttonPressed), for: .valueChanged)
        customKeypad.style = .call
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
        let contact = contactStore.getContact(for: nameLabel.text!)
        let names = (contact?.firstName ?? "") + (contact?.lastName == nil ? "": " \(contact!.lastName!)")
        let name = names == "" ? self.name! : names
        let callStore = CallStore.shared
        let callTime = minutes > 0 ? "\(minutes) minutes" : seconds > 0 ? "\(seconds) seconds" : "0"
        let callType = callTime == "0" ? "Cancelled" : "Outgoing"
        callStore.createCall(name: name, number: number, phoneType: type, date: Date(), callType: callType, callTime: callTime)
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
    
    @objc func buttonPressed(_ sender: CustomKeypad) {
        keypadInput.append(sender.keyPressed)
        changeNumberBackgroundColor(customKeypad.buttons[sender.buttonTag])
    }
    
    func changeNumberBackgroundColor(_ sender: UIView) {
        UIView.animate(withDuration: 1) {
            sender.backgroundColor = sender.backgroundColor?.withAlphaComponent(0.3)
            sender.backgroundColor = sender.backgroundColor?.withAlphaComponent(0.1)
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
