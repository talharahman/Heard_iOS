import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let firebase = FirebaseRepository()
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func signInPressed(_ sender: UIButton) {
        if let email = emailTextField.text,
            let password = passwordTextField.text {
            firebase.verifyLogin(with: email, and: password)
        }
    }
    
}

