import Foundation
import Alamofire

enum UserRouter: URLRequestConvertible {
    case login(User), signup(User), forgotPassword(User)
    
    // MARK: HTTPMethod
    private var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        case .signup:
            return .post
        case .forgotPassword:
            return .post
        }
    }
    
    // MARK: - Path
    private var path: String {
        switch self {
        case .login:
            return "/api/user_token"
        case .signup:
            return "/api/users"
        case .forgotPassword:
            return "/api/password_reset"
        }
    }
    
    // MARK: - Parameters
    private var params: Parameters? {
        switch self {
        case .login(let params):
            return [ "auth" : params.toJSON() ]
        case .signup(let params):
            return [ "user" : params.toJSON() ]
        case .forgotPassword(let params):
            return [ "password_reset" : params.toJSON() ]
        }
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        var config = Configuration()
        
        let url = try config.environment.baseURL.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        return try! Alamofire.JSONEncoding().encode(urlRequest, with: params)
    }
}
