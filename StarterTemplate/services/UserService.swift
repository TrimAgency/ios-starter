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
}

extension UserService: LoginService, SignupService {
    
}

