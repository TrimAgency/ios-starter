import ObjectMapper
import Foundation

class User: Mappable {
    
    var id: Int?
    var email: String?
    var jwt: String?
    var password: String?
    
    init() {}
    
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        id                        <- map["id"]
        email                     <- map["email"]
        jwt                       <- map["token"]
        password                  <- map["password"]
    }
}
