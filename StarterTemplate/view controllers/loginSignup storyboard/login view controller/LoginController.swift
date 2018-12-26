
import UIKit
import RxSwift
import RxCocoa

class LoginController: UIViewController, UITextFieldDelegate {

    //view props
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    //internal props
    weak var coordinator: MainCoordinator?
    let disposeBag = DisposeBag()
    let viewModel = LoginViewModel(userService: UserService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createViewModelBinding()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func goToHome() {
        // use navigator to transition after successful login
    }

}

//MARK: - textfield delegate methods
extension LoginController {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.black.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.lightGray.cgColor
        viewModel.validateForm()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        viewModel.validateForm()
        return true
    }
}

//MARK: - view model bindings
extension LoginController {
    private func createViewModelBinding() {
        emailTextField.rx.text.orEmpty
            .bind(to: viewModel.emailViewModel.data)
            .disposed(by: disposeBag)
        
        viewModel.emailViewModel.errorValue
            .asObservable()
            .bind(to: emailErrorLabel.rx.text)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text.orEmpty
            .bind(to: viewModel.passwordVieModel.data)
            .disposed(by: disposeBag)
        
        viewModel.passwordVieModel.errorValue
            .asObservable()
            .bind(to: passwordErrorLabel.rx.text)
            .disposed(by: disposeBag)
        
        loginBtn.rx.tap.do(onNext: { [unowned self] in
            self.emailTextField.resignFirstResponder()
            self.passwordTextField.resignFirstResponder()
        }).subscribe(onNext: { [unowned self] in
            if self.viewModel.validateFields() {
                self.viewModel.login()
            }
        }).disposed(by: disposeBag)
        
        viewModel.success
            .subscribe(onNext: { [unowned self] (value: Bool) in
                if value {
                    // this is here soley for debugging purposes
                    self.presentMessage(title: "Success", message: "You are now logged in")
                    self.goToHome()
                }
            }).disposed(by: disposeBag)
        viewModel.errorMsg
            .subscribe(onNext: { [unowned self] (value) in
                if !value.isEmpty {
                    self.presentError(value)
                }
            }).disposed(by: disposeBag)
        
        viewModel.isFormValid
            .subscribe(onNext: { [unowned self] (value: Bool) in
                if value {
                    self.loginBtn.enabled()
                } else {
                    self.loginBtn.disabled()
                }
            }).disposed(by: disposeBag)
    }
}
