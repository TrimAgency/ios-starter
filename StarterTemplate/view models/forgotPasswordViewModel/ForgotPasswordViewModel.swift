import Foundation
import RxCocoa
import RxSwift

struct ForgotPasswordViewModel {
    
    let user: User = User()
    let disposebag = DisposeBag()
    
    let emailViewModel = EmailViewModel()
    
    let success = BehaviorRelay<Bool>(value: false)
    let isLoading = BehaviorRelay<Bool>(value: false)
    let errorMsg = BehaviorRelay<String>(value: "")
    let isFormValid = BehaviorRelay<Bool>(value: false)
    
    private let userService: ForgotPasswordService
    
    init(userService: ForgotPasswordService) {
        self.userService = userService
    }
    
    func validateFields() -> Bool {
        return emailViewModel.validateCredentials()
    }
    
    func validateForm() {
        if validateFields() {
            isFormValid.accept(true)
        } else {
            isFormValid.accept(false)
        }
    }
    
    func forgotPassword() {
        user.email = emailViewModel.data.value
        
        isLoading.accept(true)
        
        userService.forgotPassword(with: user)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { response in
                self.isLoading.accept(false)
                self.success.accept(true)
            }, onError: { error in
                let errorObject = error as! ErrorResponseObject
                switch errorObject.type {
                case ApiResponseType.notFound:
                    self.errorMsg.accept("No user found matching that email")
                case ApiResponseType.internalServerError:
                    self.errorMsg.accept("There was an error processing your request")
                default:
                    self.errorMsg.accept("There was an error processing your request")
                }
            }).disposed(by: disposebag)
    }
}
