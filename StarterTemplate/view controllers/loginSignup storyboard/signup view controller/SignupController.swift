import UIKit
import RxSwift
import RxCocoa

class SignupController: UIViewController {
    // view props
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    // internal props
    let disposeBag = DisposeBag()
    var viewModel: SignupViewModel!
    var spinnerView: UIView!
    var finish: (() -> Void)?
    var login: (() -> Void)?
    var textFields: [UITextField] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinnerView = UIView.init(frame: view.bounds)
        
        textFields = [emailTextField, passwordTextField]
        createViewModelBinding()
    }
}

extension SignupController {
    private func createViewModelBinding() {
        // view prop bindings
        emailTextField.rx.text.orEmpty
            .bind(to: viewModel.emailViewModel.data)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text.orEmpty
            .bind(to: viewModel.passwordViewModel.data)
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
        
        signupBtn.rx.tap.do(onNext: { [unowned self] in
            self.emailTextField.resignFirstResponder()
            self.passwordTextField.resignFirstResponder()
        }).subscribe(onNext: { [unowned self] in
            if self.viewModel.validateFields() {
                self.viewModel.signup()
            }
        }).disposed(by: disposeBag)
        
        loginBtn.rx.tap.bind {
            self.login?()
        }.disposed(by: disposeBag)
        
        // view model bindings
        viewModel.emailViewModel.errorValue
            .asObservable()
            .bind(to: emailErrorLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.passwordViewModel.errorValue
            .asObservable()
            .bind(to: passwordErrorLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.success
            .drive(onNext: { [unowned self] (value: Bool) in
                if value {
                    self.removeSpinner(spinner: self.spinnerView)
                    // this is here soley for debugging purposes
                    self.presentMessage(title: "Success", message: "You are registered")
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
                    self.signupBtn.enabled()
                } else {
                    self.signupBtn.disabled()
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
