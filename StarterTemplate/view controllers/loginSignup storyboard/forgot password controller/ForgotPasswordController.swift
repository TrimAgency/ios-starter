import UIKit
import RxSwift
import RxCocoa

class ForgotPasswordController: UIViewController {

    // view props
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    
    //internal props
    let disposeBag = DisposeBag()
    var viewModel: ForgotPasswordViewModel!
    var spinnerView: UIView!
    var finish: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinnerView = UIView.init(frame: view.bounds)
        
        createViewModelBinding()
    }
}

//MARK: - view model bindings
extension ForgotPasswordController {
    private func createViewModelBinding() {
        // view prop bindings
        emailTextField.rx.text.orEmpty
            .bind(to: viewModel.emailViewModel.data)
            .disposed(by: disposeBag)
        
        emailTextField.rx
            .controlEvent(.editingDidBegin)
            .asObservable()
            .subscribe(onNext: { [unowned self] _ in
                self.emailTextField.layer.borderWidth = 1.0
                self.emailTextField.layer.borderColor = UIColor.black.cgColor
            }).disposed(by: disposeBag)
        
        emailTextField.rx
            .controlEvent(.editingDidEnd)
            .asObservable()
            .subscribe(onNext: { [unowned self] _ in
                self.emailTextField.layer.borderWidth = 1.0
                self.emailTextField.layer.borderColor = UIColor.lightGray.cgColor
                self.viewModel.validateForm()
            }).disposed(by: disposeBag)
        
        emailTextField.rx
            .controlEvent(.editingDidEndOnExit)
            .asObservable()
            .subscribe(onNext: { [unowned self] _ in
                self.emailTextField.resignFirstResponder()
                self.viewModel.validateForm()
            }).disposed(by: disposeBag)
        
        forgotPasswordBtn.rx.tap.do(onNext: { [unowned self] in
            self.emailTextField.resignFirstResponder()
        }).subscribe(onNext: { [unowned self] in
            if self.viewModel.validateFields() {
                self.viewModel.forgotPassword()
            }
        }).disposed(by: disposeBag)
        
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
                    self.presentMessage(title: "Success",
                                        message: "Check your email for instructions to reset your password")
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
                    self.forgotPasswordBtn.enabled()
                } else {
                    self.forgotPasswordBtn.disabled()
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

