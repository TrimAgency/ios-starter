import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import RxSwift

class UserService: MainRequestService {
    
    func login(with user: User) -> Observable<LoginResponse> {
        return newRequestWithoutKeyPath(route: UserRouter.login(user))
    }
    
    func signUp(with user:User) -> Observable<User> {
        return newRequestWithKeyPath(route: UserRouter.signup(user),
                                     keypath: "user")
    }
    
    func forgotPassword(with user: User) -> Observable<User> {
        return newRequestWithKeyPath(route: UserRouter.forgotPassword(user), keypath: "password_reset")
    }
}

extension UserService: LoginService, SignupService, ForgotPasswordService {
    
}

