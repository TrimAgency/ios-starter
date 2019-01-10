import Foundation
import RxCocoa
import RxSwift

struct SignupViewModel {
    
    let user: User = User()
    let disposebag = DisposeBag()
    
    let emailViewModel = EmailViewModel()
    let passwordViewModel = PasswordViewModel()
    
    let success = BehaviorRelay<Bool>(value: false)
    let isLoading = BehaviorRelay<Bool>(value: false)
    let errorMsg = BehaviorRelay<String>(value: "")
    let isFormValid = BehaviorRelay<Bool>(value: false)
    
    private let userService: SignupService
    private let userInfoService: UserInfoService
    
    init(userService: SignupService, userInfoService: UserInfoService) {
        self.userService = userService
        self.userInfoService = userInfoService
        
    }
    
    func validateFields() -> Bool {
        return emailViewModel.validateCredentials() && passwordViewModel.validateCredentials()
    }
    
    func validateForm() {
        if validateFields() {
            isFormValid.accept(true)
        } else {
            isFormValid.accept(false)
        }
    }
    
    func signup() {
        user.email = emailViewModel.data.value
        user.password = passwordViewModel.data.value
        user.profileType = "Consumer"
        user.timeZone = TimeZone.current.identifier
        
        isLoading.accept(true)
        
        userService.signUp(with: user)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { response in
                self.isLoading.accept(false)
                self.success.accept(true)
                if let jwt = response.jwt, let email = response.email {
                    self.userInfoService.setUserEmail(email: email)
                    self.userInfoService.setUserJWT(jwt: jwt)
                }
            }, onError: { error in
                let errorObject = error as! ErrorResponseObject
                switch errorObject.status {
                // handle additional errors here or pass the API error directly
                case 500:
                    self.errorMsg.accept("There was an error processing your request")
                default:
                    self.errorMsg.accept("There was an error processing your request")
                }
            }).disposed(by: disposebag)
        
    }
}
