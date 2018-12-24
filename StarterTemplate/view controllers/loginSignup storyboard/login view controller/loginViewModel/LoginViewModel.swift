
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
    
    func validateFields() -> Bool {
        return emailViewModel.validateCredentials() && passwordVieModel.validateCredentials()
    }
    
    func login() {
        user.email = emailViewModel.data.value
        user.password = passwordVieModel.data.value
        
        isLoading.accept(true)
        
        UserService.login(with: user)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { user in
                print(user)
            }, onError: { error in
                print(error)
            }).disposed(by: disposebag)
        
    }
}
