import Foundation

protocol UserInfoService {
    func setUserJWT(jwt: String) -> Void
    func setUserEmail(email: String) -> Void
    func getUserDeviceToken() -> String?
}
