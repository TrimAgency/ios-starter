
import UIKit

class ViewController: UIViewController {
    
    // services
    private var navigator: NavigatorCordinator?

    // view properties
    @IBAction func loginBtn(_ sender: UIButton) {
        if let nav = navigator {
            nav.navigate(to: .login)
        }
    }
    @IBAction func signupBtn(_ sender: UIButton) {
        if let nav = navigator {
            nav.navigate(to: .signup)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let navControl = navigationController {
            navigator = NavigatorCordinator(navController: navControl)
        }
        
        var configuration = Configuration()
        print(configuration.environment.baseURL)
    }
}

