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

    
    var name: String!
    var timer = Timer()
    var minutes = 0
    var seconds = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = name
        //keypadButton.addTarget(self, action: #selector(), for: .allEvents)
        runTimer()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        buttons.forEach {
            $0.layer.cornerRadius = $0.bounds.width * 0.5
            $0.clipsToBounds = true
        }
    }
    
    @IBAction func endCall(_ sender: UIButton) {
        let contactStore = ContactStore.shared
        let name = contactStore.contactForNumber(number: nameLabel.text!) ?? nameLabel.text!
        let callStore = CallStore.shared
        callStore.createCall(name: name, phoneType: "mobile", date: Date(), isMissed: false, hasIcon: true)
        self.dismiss(animated: false, completion: nil)
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
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
}
