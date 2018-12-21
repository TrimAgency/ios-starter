import Foundation
import KeychainSwift

class KeychainService {
    
    static let keychain = KeychainSwift()
    
    static func setUserJWT(jwt: String) {
        keychain.set(jwt, forKey: "jwt")
    }
    
    static func getUserJWT() -> String? {
        return keychain.get("jwt")
    }
    
    static func setUserEmail(email: String) {
        keychain.set(email, forKey: "email")
    }
    
    static func getUserEmail() -> String? {
        return keychain.get("email")
    }
    
    static func getUserPassword() -> String? {
        return keychain.get("password")
    }
    
    static func setUserPassword(password: String) {
        keychain.set(password, forKey: "password")
    }
    
    
    static func setRememberTrue() {
        keychain.set(true, forKey: "remember")
    }
    
    static func isRemember() -> Bool {
        if let remember =  keychain.getBool("remember") {
            return remember
        }
        
        return false
    }
    
    static func clearValues() {
        keychain.clear()
    }
}

