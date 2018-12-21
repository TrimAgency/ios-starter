import UIKit
import Foundation

class AlertService {
    
    func showMessage(buttonText: String = "Ok",
                     message: String = "",
                     title: String = "Error:"
        )  -> UIAlertController {
        let title = title
        let message = message
        let action = UIAlertAction(title: buttonText, style: .default, handler: nil)
        
        return displayAlert(for: title, with: message, action: action)
    }
    
    private func displayAlert(for title: String,
                              with message: String,
                              action: UIAlertAction) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(action)
        
        return alert
    }
}
