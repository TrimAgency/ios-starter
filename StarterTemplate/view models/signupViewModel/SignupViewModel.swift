import Foundation
import RxCocoa
import RxSwift

struct SignupViewModel {
    
    let user: User = User()
    let disposebag = DisposeBag()
    
    let emailViewModel = EmailViewModel()
    let passwordViewModel = PasswordViewModel()
    
    private let _success = BehaviorRelay<Bool>(value: false)
    private let _isLoading = BehaviorRelay<Bool>(value: false)
    private let _errorMsg = BehaviorRelay<String>(value: "")
    private let _isFormValid = BehaviorRelay<Bool>(value: false)
    
    var success: Driver<Bool> { return _success.asDriver() }
    var isLoading: Driver<Bool> { return _isLoading.asDriver() }
    var errorMsg: Driver<String> { return _errorMsg.asDriver() }
    var isFormValid: Driver<Bool> { return _isFormValid.asDriver() }
    
    
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
            _isFormValid.accept(true)
        } else {
            _isFormValid.accept(false)
        }
    }
    
    func signup() {
        user.email = emailViewModel.data.value
        user.password = passwordViewModel.data.value
        user.profileType = "Consumer"
        user.timeZone = TimeZone.current.identifier
        user.device = createUserDevice()
        
        _isLoading.accept(true)
        
        userService.signUp(with: user)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { response in
                self._isLoading.accept(false)
                self._success.accept(true)
                if let jwt = response.jwt, let email = response.email {
                    self.userInfoService.setUserEmail(email: email)
                    self.userInfoService.setUserJWT(jwt: jwt)
                }
            }, onError: { error in
                guard let errorObject = error as? ErrorResponseObject else { return }
                switch errorObject.status {
                // handle additional errors here or pass the API error directly
                case 500:
                    self._errorMsg.accept("There was an error processing your request")
                default:
                    self._errorMsg.accept("There was an error processing your request")
                }
            }).disposed(by: disposebag)
        
    }
    
    private func createUserDevice() -> Device {
        let device = Device()
        if let token = userInfoService.getUserDeviceToken() {
            device.deviceToken = token
            device.platform = "apn"
        }
        
        return device
    }
}
