import UIKit

class CustomKeypadViewController: UIViewController {
    @IBOutlet var customKeypad: CustomKeypad!
    
    var buttons: [CustomButton]!
    
    let viewLabels = [
        ("1","",nil),
        ("2","A B C",nil),
        ("3","D E F",nil),
        ("4","G H I",nil),
        ("5","J K L",nil),
        ("6","M N O",nil),
        ("7","P Q R S",nil),
        ("8","T U V",nil),
        ("9","W X Y Z",nil),
        ("*","",nil),
        ("0","+",nil),
        ("#","",nil),
        ("","",nil),
        ("","",UIImage(named: "phone.fill")),
        ("","",UIImage(named: "delete.left.fill"))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewLabels.forEach {
            let button = CustomButton()
            button.setView($0)
            customKeypad.addButton(button)
        }
        print(customKeypad.buttons.count)
        
    }
}
