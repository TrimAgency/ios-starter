import UIKit

class AppButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        layer.cornerRadius = 24
        layer.masksToBounds = true
        layer.backgroundColor = UIColor.Starter.maize.cgColor
    }
    
    func enableButton() {
        layer.backgroundColor = UIColor.black.cgColor
        isEnabled = true
    }
    
    func disableButton() {
        layer.backgroundColor = UIColor.lightGray.cgColor
        isEnabled = false
    }
}
