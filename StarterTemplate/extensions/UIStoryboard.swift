
import Foundation
import UIKit

extension UIStoryboard {
    
    // MARK: - Storyboards
    static var main: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
    
    static var loginSignup: UIStoryboard {
        return UIStoryboard(name: "LoginSignup", bundle: Bundle.main)
    }
    
    // MARK: - View Controllers
    static var viewController: ViewController {
        return UIStoryboard.main.instantiateViewController(withIdentifier: ViewController.storyboardIdentifier) as! ViewController
    }
    
    static var loginController: LoginController {
        return UIStoryboard.loginSignup.instantiateViewController(withIdentifier: LoginController.storyboardIdentifier) as! LoginController
    }
    
    static var signupController: SignupController {
        return UIStoryboard.loginSignup.instantiateViewController(withIdentifier: SignupController.storyboardIdentifier) as! SignupController
    }
}
