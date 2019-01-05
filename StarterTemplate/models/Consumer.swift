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

