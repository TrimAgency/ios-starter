import Foundation

enum Constants: String {
    case Development = "Development"
    case Staging = "Staging"
    case Release = "Release"
    case Testing = "Testing"
    
    var baseURL: String {
        switch self {
        case .Development: return "https://starter-api.ngrok.io"
        case .Testing: return "http://localhost:8080"
        case .Staging: return "https://staging-api.heroku.com"
        case .Release: return "https://production-api.heroku.com"
        }
    }
}
