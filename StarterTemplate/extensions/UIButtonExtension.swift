
import Foundation
import UIKit

extension UIButton {
    
    // underline text of button
    func underline() {
        guard let text = self.titleLabel?.text else { return }
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: text.count))
        
        self.setAttributedTitle(attributedString, for: .normal)
    }
    
    func disabled() {
        isEnabled = false
        layer.backgroundColor = UIColor.gray.cgColor
    }
    
    func enabled() {
        isEnabled = true
        layer.backgroundColor = UIColor.green.cgColor
    }
}
