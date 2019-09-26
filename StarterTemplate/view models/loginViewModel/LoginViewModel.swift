
import Foundation
import RxCocoa
import RxSwift

struct LoginViewModel {
    
    let user: User = User()
    let disposebag = DisposeBag()
    
    let emailViewModel = EmailViewModel()
    let passwordVieModel = PasswordViewModel()
    
    private let _success = BehaviorRelay<Bool>(value: false)
    private let _isLoading = BehaviorRelay<Bool>(value: false)
    private let _errorMsg = BehaviorRelay<String>(value: "")
    private let _isFormValid = BehaviorRelay<Bool>(value: false)
    
    var success: Driver<Bool> { return _success.asDriver() }
    var isLoading: Driver<Bool> { return _isLoading.asDriver() }
    var errorMsg: Driver<String> { return _errorMsg.asDriver() }
    var isFormValid: Driver<Bool> { return _isFormValid.asDriver() }
    
    private let userService: LoginService
    private let userInfoService: UserInfoService
    private let deviceService: DeviceService
    
    init(userService: LoginService, userInfoService: UserInfoService, deviceService: DeviceService) {
        self.userService = userService
        self.userInfoService = userInfoService
        self.deviceService = deviceService
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
    
    func login() {
        user.email = emailViewModel.data.value
        user.password = passwordVieModel.data.value
        
        _isLoading.accept(true)
        
        userService.login(with: user)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { response in
                if let jwt = response.jwt {
                    self._isLoading.accept(false)
                    self._success.accept(true)
                    self.userInfoService.setUserJWT(jwt: jwt)
                }
                
                if let user = response.user {
                    self.deviceTokenCheck(for: user)
                }
            }, onError: { error in
                guard let errorObject = error as? ErrorResponseObject else { return }
                
                switch errorObject.status {
                    // handle additional errors here or pass the API error directly
                case 404:
                    self._errorMsg.accept("No user found matching username / password")
                case 500:
                    self._errorMsg.accept("There was an error processing your request")
                default:
                    self._errorMsg.accept("There was an error processing your request")
                }
            }).disposed(by: disposebag)
        
    }
    
    private func deviceTokenCheck(for user: User) {
        if let userDeviceToken = user.device?.deviceToken,
            let deviceId = user.device?.id,
            let token = userInfoService.getUserDeviceToken() {
            
            if userDeviceToken != token {
                let device = Device()
                device.id = deviceId
                device.deviceToken = token
                device.platform = "apn"
                
                updateDevice(for: device)
            }
            
        } else if user.device == nil {
            if let token = userInfoService.getUserDeviceToken() {
                let device = Device()
                device.deviceToken = token
                device.platform = "apn"
                
                createDevice(for: device)
            }
        }
    }
    
    private func updateDevice(for device: Device) {
        deviceService.update(with: device)
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .retry(2)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposebag)
    }
    
    private func createDevice(for device: Device) {
        deviceService.create(with: device)
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .retry(2)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposebag)
    }
}
