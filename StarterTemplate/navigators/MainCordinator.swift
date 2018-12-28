
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
        initialVC.coordinator = self
        navigationController.pushViewController(initialVC, animated: false)
    }
    
    func login() {
        let vc = UIStoryboard.loginController
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func signup() {
        let vc = UIStoryboard.signupController
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func forgotPassword() {
        let vc = UIStoryboard.forgotPasswordController
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
}

