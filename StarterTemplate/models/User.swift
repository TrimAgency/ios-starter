import ObjectMapper
import Foundation

class Consumer: Mappable {
    
    var id: Int?
    var firstName: String?
    var lastName: String?
    
    init() {}
    
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        id                        <- map["id"]
        lastName                  <- map["last_name"]
        firstName                 <- map["first_name"]
    }
}


class User: Mappable {
    
    var id: Int?
    var email: String?
    var jwt: String?
    var password: String?
    var profileType: String?
    var timeZone: String?
    var consumer: Consumer?
    
    init() {}
    
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        id                        <- map["id"]
        email                     <- map["email"]
        jwt                       <- map["token"]
        password                  <- map["password"]
        profileType               <- map["profile_type"]
        timeZone                  <- map["time_zone"]
        consumer                  <- map["consumer"]
    }
}
