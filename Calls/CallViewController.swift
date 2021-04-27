//
//  CallViewController.swift
//  Calls
//
//  Created by Svetoslav Kanchev on 26.04.21.
//

import UIKit

class CallViewController: UIViewController {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var buttons: [UIButton]!
    
    var name: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = name
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        buttons.forEach {
            $0.layer.cornerRadius = $0.bounds.width * 0.5
            $0.clipsToBounds = true
        }
    }
    
    @IBAction func endCall(_ sender: UIButton) {
        let recentViewController = RecentViewController()
        recentViewController.initt()
        let callStore = recentViewController.callStore
        
        let contactViewController = ContactViewController()
        contactViewController.initt()
        let contactStore = contactViewController.contactStore
        let name = contactStore!.contactForNumber(number: nameLabel.text!) ?? nameLabel
            .text!
        callStore!.createCall(name: name, phoneType: "mobile", date: Date(), isMissed: false, hasIcon: true)
        self.dismiss(animated: false, completion: nil)
    }
}
