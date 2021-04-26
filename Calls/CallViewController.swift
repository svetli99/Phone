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
        self.dismiss(animated: false, completion: nil)
    }
}
