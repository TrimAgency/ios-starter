
import Foundation
import UIKit

class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navController: UINavigationController) {
        navigationController = navController
    }
    
    func start() {
        let initialVC = UIStoryboard.viewController
        
        initialVC.login = { [weak self] in
            self?.login()
        }
        
        initialVC.signup = { [weak self] in
            self?.signup()
        }
        
        navigationController.pushViewController(initialVC, animated: false)
    }
    
    func login() {
        let vc = UIStoryboard.loginController
        
        let viewModel = LoginViewModel(userService: UserService(),
                                       userInfoService: KeychainService(),
                                       deviceService: DeviceService())
        
        vc.viewModel = viewModel
        
        vc.forgotPassword = { [weak self] in
            self?.forgotPassword()
        }
        
        vc.signup = { [weak self] in
            self?.signup()
        }
        
        vc.finish = { [weak self] in
            self?.start()
        }
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    func signup() {
        let vc = UIStoryboard.signupController
        let viewModel = SignupViewModel(userService: UserService(),
                                        userInfoService: KeychainService())
        
        vc.viewModel = viewModel
        
        vc.finish = { [weak self] in
            self?.start()
        }
        
        vc.login = { [weak self] in
            self?.login()
        }
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    func forgotPassword() {
        let vc = UIStoryboard.forgotPasswordController
        let viewModel = ForgotPasswordViewModel(userService: UserService())
        
        vc.viewModel = viewModel
        
        navigationController.pushViewController(vc, animated: true)
    }
}

