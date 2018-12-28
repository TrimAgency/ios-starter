import UIKit

extension UIViewController {
    
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
    
    func displaySpinner(onView: UIView, spinnerView: UIView) {
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
    }
    
    func removeSpinner(spinner: UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
    
    func presentError(_ error: String) {
        let alertController = UIAlertController(title: "Error",
                                                message: error,
                                                preferredStyle: .alert)
        alertController.addAction(.init(title: "OK", style: .default))
        self.present(alertController, animated: true)
    }
    
    func presentMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(.init(title: "OK", style: .default))
        self.present(alertController, animated: true)
    }
}
