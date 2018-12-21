import UIKit
import Foundation

// add all view controllers
// to enable navigator cordinator
// handling all VC pushing
enum Destination {
    case view, login, signup
    
    
    var controller: UIViewController {
        switch self {
        case .view:
            return instantiateVC(for: "initialVC")
        case .login:
            return instantiateVC(for: "loginVC", "LoginSignup")
        case .signup:
            return instantiateVC(for: "signupVC", "LoginSignup")
        }
    }
    
    func instantiateVC(for name: String, _ storyboard: String = "Main") -> UIViewController {
        return  UIStoryboard(name: storyboard, bundle: nil).instantiateViewController(withIdentifier: name)
    }
}

