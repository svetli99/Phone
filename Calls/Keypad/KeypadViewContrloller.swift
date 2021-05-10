//
//  KeypadViewContrloller.swift
//  Calls
//
//  Created by Svetoslav Kanchev on 23.04.21.
//

import UIKit

class KeypadViewController: UIViewController {
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var addNumberButton: UIButton!
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var callButton: UIButton!
    @IBOutlet var customKeypad: CustomKeypad!
    
    var plusPressed = false
   
    let countryCodes: Set<String> = ["389", "84", "590", "31", "880", "688", "886", "964", "974", "266", "359", "508", "229", "501", "995", "44", "267", "48", "372", "264", "230", "680", "970", "340", "596", "33", "687", "968", "41", "269", "232", "358", "299", "594", "502", "238", "676", "258", "251", "670", "226", "382", "225", "376", "509", "500", "32", "591", "690", "966", "261", "378", "53", "90", "221", "345", "36", "62", "691", "375", "56", "960", "213", "216", "381", "507", "243", "855", "965", "92", "86", "7", "377", "852", "351", "260", "30", "265", "237", "240", "242", "503", "298", "268", "256", "850", "872", "60", "853", "98", "976", "39", "371", "967", "370", "387", "234", "49", "248", "250", "94", "971", "290", "58", "994", "689", "963", "962", "228", "692", "380", "239", "992", "506", "223", "996", "77", "421", "43", "599", "95", "34", "55", "386", "246", "856", "81", "678", "353", "27", "65", "61", "254", "681", "45", "57", "686", "972", "679", "354", "977", "40", "350", "672", "537", "47", "257", "236", "993", "998", "385", "93", "291", "420", "674", "683", "66", "255", "82", "961", "212", "356", "227", "673", "220", "975", "262", "253", "249", "597", "675", "224", "593", "355", "64", "682", "1", "231", "263", "374", "373", "244", "973", "505", "252", "677", "235", "297", "233", "685", "222", "91", "20", "245", "52", "379", "218", "54", "595", "423", "504", "46", "51", "63", "284", "352", "598", "241"]
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        callButton.layer.cornerRadius = callButton.bounds.width * 0.5
        callButton.clipsToBounds = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addNumberButton.isHidden = true
        customKeypad.buttons.forEach {
            $0.button.addTarget(self, action: #selector(buttonPressed), for: .touchDown)
        }
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        if let first = numberLabel.text!.first {
            switch first {
            case "0":
                if numberLabel.text!.count == 3 {
                    numberLabel.text!.append(" ")
                }
            case "+":
                if !(2...4 ~= numberLabel.text!.count) {
                    break
                }
                var code = numberLabel.text!
                code.removeFirst()
                if countryCodes.contains(code) {
                    numberLabel.text!.append(" ")
                    break
                }
            default:
                if numberLabel.text!.count == 2 {
                    numberLabel.text!.append(" ")
                }
            }
        }
        
        numberLabel.text?.append(sender.currentTitle!)
        
        if numberLabel.text!.count == 1 {
            addNumberButton.isHidden = false
            deleteButton.isHidden = false
        }
        changeNumberBackgroundColor(customKeypad.buttons[sender.tag])
    }
    
    @IBAction func deleteButton(_ sender: UIButton) {
        if !numberLabel.text!.isEmpty {
            if numberLabel.text!.last == " " {
                numberLabel.text!.removeLast()
            }
            numberLabel.text!.removeLast()
            addNumberButton.isHidden = numberLabel.text!.isEmpty
            deleteButton.imageView?.isHidden = numberLabel.text!.isEmpty
            //deleteButton.isHidden = numberLabel.text!.isEmpty
        }
    }
    @IBAction func longPressZero(_ sender: UILongPressGestureRecognizer) {
        plusPressed.toggle()
        if plusPressed {
            numberLabel.text?.append("+")
            if numberLabel.text!.count == 1 {
                addNumberButton.isHidden = false
                deleteButton.isHidden = false
            }
        }
    }
    
    func changeNumberBackgroundColor(_ sender: UIView) {
        UIView.animate(withDuration: 1) {
            sender.backgroundColor = .systemGray3
            sender.backgroundColor = .systemGray5
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CallViewController" {
            let callViewController = segue.destination as! CallViewController
            callViewController.name = numberLabel.text
        } else if segue.identifier != "Keypad" {
            preconditionFailure("Unexpected segue identifier.")
        }
    }
}
