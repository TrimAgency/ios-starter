
import UIKit

class LoginController: UIViewController, UITextFieldDelegate {

    //view props
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginBtn: AppButton!
    
    @IBAction func loginBtnPress(_ sender: UIButton) {
    }
    
    //internal props
    
    //services
    let alertService = AlertService()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.delegate = self
        passwordTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

//MARK: - textfield delegate methods
extension LoginController {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.black.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.lightGray.cgColor
        
        validateLoginBtn()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        validateLoginBtn()
        
        return true
    }
    
    private func validateLoginBtn() {
        if formValid() {
            loginBtn.enableButton()
        } else {
            loginBtn.disableButton()
        }
    }
    
    private func formValid() -> Bool{
        return emailTextField.text != "" && passwordTextField.text != ""
    }
    
    private func populateFieldsIfExist() {
        if let email = KeychainService.getUserEmail() {
            emailTextField.text = email
        }
        
        if let password = KeychainService.getUserPassword() {
            passwordTextField.text = password
        }
    }
}

//MARK - http methods
extension LoginController {
    
    private func login() {
        let user = User()
        user.email = emailTextField.text
        user.password = passwordTextField.text
        
        UserService.login(with: user,
                          completion: loggedIn,
                          errorCompletion: errorLoggingIn)
        
    }
    
    private func loggedIn(user: User) {
        
    }
    
    private func errorLoggingIn(error: Any) {
        
    }
}


