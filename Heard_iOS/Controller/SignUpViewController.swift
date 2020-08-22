
import UIKit

class SignUpViewController : UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    let firebase = FirebaseRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        if let email = emailTextField.text,
            let password = passwordTextField.text,
            let username = usernameTextField.text {
            firebase.createUser(with: email, password: password, and: username)
        }
    }
}
