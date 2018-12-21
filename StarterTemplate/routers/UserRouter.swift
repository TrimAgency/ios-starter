import Foundation
import Alamofire

enum UserRouter: URLRequestConvertible {
    case login(User), signUp(User)
    
    // MARK: HTTPMethod
    private var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        case .signUp:
            return .post
        }
    }
    
    // MARK: - Path
    private var path: String {
        switch self {
        case .login:
            return "/api/v1/login"
        case .signUp:
            return "/api/v1/sign_up"
        }
    }
    
    // MARK: - Parameters
    private var params: Parameters? {
        switch self {
        case .login(let params):
            return [ "user" : params.toJSON() ]
        case .signUp(let params):
            return [ "user" : params.toJSON() ]
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
