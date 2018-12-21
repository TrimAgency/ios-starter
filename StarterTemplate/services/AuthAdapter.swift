import Foundation
import Alamofire

class AuthAdapter: RequestAdapter {
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        if let jwt = KeychainService.getUserJWT() {
            urlRequest.setValue("Bearer " + jwt, forHTTPHeaderField: "Authorization")
        }
        return urlRequest
    }
}
