
import UIKit
import RxSwift
import RxCocoa

class LoginController: UIViewController, UITextFieldDelegate {

    //view props
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    @IBOutlet weak var signupBtn: UIButton!
    
    //internal props
    let disposeBag = DisposeBag()
    var viewModel: LoginViewModel!
    var spinnerView: UIView!
    var forgotPassword: (() -> Void)?
    var signup: (() -> Void)?
    var finish: (() -> Void)?
    var textFields: [UITextField] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinnerView = UIView.init(frame: view.bounds)
        
        textFields = [emailTextField, passwordTextField]
        createViewModelBinding()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//MARK: - view model bindings
extension LoginController {
    private func createViewModelBinding() {
        // view prop bindings
        emailTextField.rx.text.orEmpty
            .bind(to: viewModel.emailViewModel.data)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text.orEmpty
            .bind(to: viewModel.passwordVieModel.data)
            .disposed(by: disposeBag)
        
        for textField in textFields {
            textField.rx
                .controlEvent(.editingDidBegin)
                .asObservable()
                .subscribe(onNext: { _ in
                    textField.layer.borderWidth = 1.0
                    textField.layer.borderColor = UIColor.black.cgColor
                }).disposed(by: disposeBag)
            
            textField.rx
                .controlEvent(.editingDidEnd)
                .asObservable()
                .subscribe(onNext: { [unowned self] _ in
                    textField.layer.borderWidth = 1.0
                    textField.layer.borderColor = UIColor.lightGray.cgColor
                    self.viewModel.validateForm()
                }).disposed(by: disposeBag)
            
            textField.rx
                .controlEvent(.editingDidEndOnExit)
                .asObservable()
                .subscribe(onNext: { [unowned self] _ in
                    textField.resignFirstResponder()
                    self.viewModel.validateForm()
                }).disposed(by: disposeBag)
        }
        
        loginBtn.rx.tap.do(onNext: { [unowned self] in
            self.emailTextField.resignFirstResponder()
            self.passwordTextField.resignFirstResponder()
        }).subscribe(onNext: { [unowned self] in
            if self.viewModel.validateFields() {
                self.viewModel.login()
            }
        }).disposed(by: disposeBag)
        
        forgotPasswordBtn.rx.tap.bind {
            self.forgotPassword?()
        }.disposed(by: disposeBag)
        
        signupBtn.rx.tap.bind {
            self.signup?()
        }.disposed(by: disposeBag)
        
        // view modal bindings
        viewModel.emailViewModel.errorValue
            .asObservable()
            .bind(to: emailErrorLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.success
            .drive(onNext: { [unowned self] (value: Bool) in
                if value {
                    self.removeSpinner(spinner: self.spinnerView)
                    // this is here soley for debugging purposes
                    self.presentMessage(title: "Success", message: "You are now logged in")
                    self.finish?()
                }
            }).disposed(by: disposeBag)
        viewModel.errorMsg
            .drive(onNext: { [unowned self] (value) in
                if !value.isEmpty {
                    self.removeSpinner(spinner: self.spinnerView)
                    self.presentError(value)
                }
            }).disposed(by: disposeBag)
        
        viewModel.isFormValid
            .drive(onNext: { [unowned self] (value: Bool) in
                if value {
                    self.loginBtn.enabled()
                } else {
                    self.loginBtn.disabled()
                }
            }).disposed(by: disposeBag)
        
        viewModel.isLoading
            .drive(onNext: { [unowned self] (value: Bool) in
                if value {
                    self.displaySpinner(onView: self.view,
                                        spinnerView: self.spinnerView)
                }
            }).disposed(by: disposeBag)
    }
}
