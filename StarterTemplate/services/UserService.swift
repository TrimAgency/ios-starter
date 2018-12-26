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
    
    func saveJWT(for jwt: String) {
        KeychainService.setUserJWT(jwt: jwt)
    }
    
    func logout() {
        KeychainService.clearValues()
    }
}

extension UserService: LoginService {
    
}

