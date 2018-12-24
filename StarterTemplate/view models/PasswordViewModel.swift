
import Foundation
import RxSwift
import RxCocoa

struct PasswordViewModel: ValidationViewModel {
    var errorMessage: String = "Please enter a valid Password"
    
    var data = BehaviorRelay<String>(value: "")
    var errorValue = BehaviorRelay<String>(value: "")
    
    func validateCredentials() -> Bool {
        
        guard validateLength(text: data.value, size: (6,15)) else {
            errorValue.accept(errorMessage)
            return false;
        }
        
        errorValue.accept("")
        return true
    }
    
    func validateLength(text: String, size: (min: Int, max: Int)) -> Bool{
        return (size.min...size.max).contains(text.count)
    }
}
