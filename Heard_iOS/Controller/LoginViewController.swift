import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        signInButton.layer.cornerRadius =
            signInButton.frame.size.height / 5
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func signInPressed(_ sender: UIButton) {
        if let email = emailTextField.text,
            let password = passwordTextField.text {
            
            Auth.auth().signIn(withEmail: email, password: password) {
                 authResult, error in
                 if let e = error {
                 print(e.localizedDescription)
                 } else {
                     self.performSegue(withIdentifier: "ActionLoginToUser", sender: self)
                 }
            }
            
        }
    }
    
}

