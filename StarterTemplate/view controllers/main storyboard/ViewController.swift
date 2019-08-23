
import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    // view properties
    let loginBtn = AppButton()
    let signupBtn = AppButton()
    
    // internal props
    var login: (() -> Void)?
    var signup: (() -> Void)?
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupBindings()
    }
}

// MARK: - Setup view
extension ViewController {
    private func setupView() {
        setupLoginBtn()
        setupSignupBtn()
    }
    
    private func setupLoginBtn() {
        loginBtn.translatesAutoresizingMaskIntoConstraints = false
        loginBtn.setTitle(TextContent.Buttons.login, for: .normal)
        
        view.addSubview(loginBtn)
        
        NSLayoutConstraint.activate([
            loginBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginBtn.widthAnchor.constraint(equalToConstant: 150),
            loginBtn.heightAnchor.constraint(equalToConstant: 50)
            ])
    }
    
    private func setupSignupBtn() {
        signupBtn.translatesAutoresizingMaskIntoConstraints = false
        signupBtn.setTitle(TextContent.Buttons.signup, for: .normal)
        
        view.addSubview(signupBtn)
        
        NSLayoutConstraint.activate([
            signupBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signupBtn.topAnchor.constraint(equalTo: loginBtn.bottomAnchor, constant: 15),
            signupBtn.widthAnchor.constraint(equalToConstant: 150),
            signupBtn.heightAnchor.constraint(equalToConstant: 50)
            ])
    }
}

// MARK: - Setup Bindings
extension ViewController {
    private func setupBindings() {
        loginBtn.rx.tap.bind { [unowned self] in
            self.login?()
            }.disposed(by: disposeBag)
        
        signupBtn.rx.tap.bind { [unowned self] in
            self.signup?()
            }.disposed(by: disposeBag)
    }
}

