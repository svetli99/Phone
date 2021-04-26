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
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        buttons.forEach {
            $0.layer.cornerRadius = $0.bounds.width * 0.5
            $0.clipsToBounds = true
        }
    }
}
