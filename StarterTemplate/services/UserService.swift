import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import RxSwift

class UserService: MainRequestService {
    
    static func login(with user: User) -> Observable<User> {
        return newRequest(UserRouter.login(user), keypath: "user")
    }
    
    static func signUp(with user:User) -> Observable<User> {
        return newRequest(UserRouter.signup(user), keypath: "user")
        
    }
    
    static func saveJWT(for jwt: String) {
        KeychainService.setUserJWT(jwt: jwt)
    }
    
    static func logout() {
        KeychainService.clearValues()
    }
}

extension UserService: LoginService {
    
}

