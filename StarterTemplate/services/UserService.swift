import Foundation
import Alamofire
import AlamofireObjectMapper

class UserService {
    
    static func login(with user:User,
                      completion: @escaping (_ user: User) -> Void,
                      errorCompletion: @escaping (_ error: Any) -> Void) {
        
        APIClient.session
            .request(UserRouter.login(user))
            .validate()
            .responseObject(keyPath: "user") { (response: DataResponse<User>) in
                
                switch response.result {
                case .success(let user):
                    if let jwt = user.jwt {
                        saveJWT(for: jwt)
                    }
                    completion(user)
                case .failure(let error):
                    if error is AFError {
                        print(error)
                        errorCompletion(error)
                    }
                }
        }
    }
    
    static func signUp(with user:User,
                       completion: @escaping (_ user: User) -> Void,
                       errorCompletion: @escaping (_ error: Any) -> Void) {
        
        APIClient.session
            .request(UserRouter.signUp(user))
            .validate()
            .responseObject(keyPath: "user") { (response: DataResponse<User>) in
                
                switch response.result {
                case .success(let user):
                    if let jwt = user.jwt {
                        saveJWT(for: jwt)
                    }
                    completion(user)
                case .failure(let error):
                    if error is AFError {
                        print(error)
                        errorCompletion(error)
                    }
                }
        }
    }
    
    static func saveJWT(for jwt: String) {
        KeychainService.setUserJWT(jwt: jwt)
    }
    
    static func logout() {
        KeychainService.clearValues()
    }
    
}

