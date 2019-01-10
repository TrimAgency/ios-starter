
import Foundation
import RxCocoa
import RxSwift

struct LoginViewModel {
    
    let user: User = User()
    let disposebag = DisposeBag()
    
    let emailViewModel = EmailViewModel()
    let passwordVieModel = PasswordViewModel()
    
    let success = BehaviorRelay<Bool>(value: false)
    let isLoading = BehaviorRelay<Bool>(value: false)
    let errorMsg = BehaviorRelay<String>(value: "")
    let isFormValid = BehaviorRelay<Bool>(value: false)
    
    private let userService: LoginService
    private let userInfoService: UserInfoService
    
    init(userService: LoginService, userInfoService: UserInfoService) {
        self.userService = userService
        self.userInfoService = userInfoService
        
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
    
    func login() {
        user.email = emailViewModel.data.value
        user.password = passwordVieModel.data.value
        
        isLoading.accept(true)
        
        userService.login(with: user)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { response in
                if let jwt = response.jwt {
                    self.isLoading.accept(false)
                    self.success.accept(true)
                    self.userInfoService.setUserJWT(jwt: jwt)
                }
            }, onError: { error in
                let errorObject = error as! ErrorResponseObject
                switch errorObject.status {
                    // handle additional errors here or pass the API error directly
                case 404:
                    self.errorMsg.accept("No user found matching username / password")
                case 500:
                    self.errorMsg.accept("There was an error processing your request")
                default:
                    self.errorMsg.accept("There was an error processing your request")
                }
            }).disposed(by: disposebag)
        
    }
    
    func deviceTokenCheck() {
        
    }
}
