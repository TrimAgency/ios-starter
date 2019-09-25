
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
                
                if let user = response.user {
                    self.deviceTokenCheck(for: user)
                }
            }, onError: { error in
                guard let errorObject = error as? ErrorResponseObject else { return }
                
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
