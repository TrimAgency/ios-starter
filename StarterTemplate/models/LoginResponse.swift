import Foundation
import ObjectMapper
import Foundation

class LoginResponse: Mappable {
    var jwt: String?
    
    init() {}
    
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        jwt                       <- map["jwt"]
    }
}
