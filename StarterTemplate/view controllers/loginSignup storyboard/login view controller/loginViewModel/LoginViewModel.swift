
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
    
    private let userService: UserService
    
    init(userService: UserService) {
        self.userService = userService
    }
    
    func validateFields() -> Bool {
        return emailViewModel.validateCredentials() && passwordVieModel.validateCredentials()
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
                    self.success.accept(true)
                    self.userService.saveJWT(for: jwt)
                }
            }, onError: { error in
                switch error {
                case ApiError.notFound:
                    self.errorMsg.accept("not found")
                default:
                    self.errorMsg.accept("unkown error")
                }
            }).disposed(by: disposebag)
        
    }
}
