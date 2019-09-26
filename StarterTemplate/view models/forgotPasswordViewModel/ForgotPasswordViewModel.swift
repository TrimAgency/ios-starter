import Foundation
import RxCocoa
import RxSwift

struct ForgotPasswordViewModel {
    
    let user: User = User()
    let disposebag = DisposeBag()
    
    let emailViewModel = EmailViewModel()
    
    private let _success = BehaviorRelay<Bool>(value: false)
    private let _isLoading = BehaviorRelay<Bool>(value: false)
    private let _errorMsg = BehaviorRelay<String>(value: "")
    private let _isFormValid = BehaviorRelay<Bool>(value: false)
    
    var success: Driver<Bool> { return _success.asDriver() }
    var isLoading: Driver<Bool> { return _isLoading.asDriver() }
    var errorMsg: Driver<String> { return _errorMsg.asDriver() }
    var isFormValid: Driver<Bool> { return _isFormValid.asDriver() }
    
    
    private let userService: ForgotPasswordService
    
    init(userService: ForgotPasswordService) {
        self.userService = userService
    }
    
    func validateFields() -> Bool {
        return emailViewModel.validateCredentials()
    }
    
    func validateForm() {
        if validateFields() {
            _isFormValid.accept(true)
        } else {
            _isFormValid.accept(false)
        }
    }
    
    func forgotPassword() {
        user.email = emailViewModel.data.value
        
        _isLoading.accept(true)
        
        userService.forgotPassword(with: user)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { response in
                self._isLoading.accept(false)
                self._success.accept(true)
            }, onError: { error in
                guard let errorObject = error as? ErrorResponseObject else { return }
                switch errorObject.status {
                // handle additional errors here or pass the API error directly
                case 404:
                    self._errorMsg.accept("No user found matching that email")
                case 500:
                    self._errorMsg.accept("There was an error processing your request")
                default:
                    self._errorMsg.accept("There was an error processing your request")
                }
            }).disposed(by: disposebag)
    }
}
