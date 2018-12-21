
import UIKit

class ViewController: UIViewController {

    // view properties
    @IBAction func loginBtn(_ sender: UIButton) {
        coordinator?.login()
    }
    @IBAction func signupBtn(_ sender: UIButton) {
        coordinator?.signup()
    }
    
    // internal props
    weak var coordinator: MainCoordinator?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var configuration = Configuration()
        print(configuration.environment.baseURL)
    }
}

