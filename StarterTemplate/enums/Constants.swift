import Foundation

enum Constants: String {
    case Development = "Development"
    case Staging = "Staging"
    case Release = "Release"
    
    var baseURL: String {
        switch self {
        // should make UITesting Build to seperate out baseUrl
        case .Development: return "http://localhost:8080"
        case .Staging: return "https://staging-api.heroku.com"
        case .Release: return "https://production-api.heroku.com"
        }
    }
}
