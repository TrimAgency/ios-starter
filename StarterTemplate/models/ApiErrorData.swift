import ObjectMapper
import Foundation

class ErrorType: Mappable, Codable {
    var email: [String]?
    
    init() {}
    
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        email    <- map["email"]
    }
}

class ApiErrorData: Mappable, Codable {
    
    var errors: ErrorType?
    
    init() {}
    
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
       
    }
}
