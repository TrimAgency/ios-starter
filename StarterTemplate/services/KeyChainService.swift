import Foundation
import KeychainSwift

class KeychainService {
    
    let keychain = KeychainSwift()
    
    func setUserJWT(jwt: String) {
        keychain.set(jwt, forKey: "jwt")
    }
    
    func getUserJWT() -> String? {
        return keychain.get("jwt")
    }
    
    func setUserEmail(email: String) {
        keychain.set(email, forKey: "email")
    }
    
    func getUserEmail() -> String? {
        return keychain.get("email")
    }
    
    func getUserPassword() -> String? {
        return keychain.get("password")
    }
    
    func setUserPassword(password: String) {
        keychain.set(password, forKey: "password")
    }
    
    
    func setRememberTrue() {
        keychain.set(true, forKey: "remember")
    }
    
    func isRemember() -> Bool {
        if let remember =  keychain.getBool("remember") {
            return remember
        }
        
        return false
    }
    
    func clearValues() {
        keychain.clear()
    }
}

extension KeychainService: UserInfoService {
    
}

