import Foundation

enum Constants: String {
    case Development = "Development"
    case Staging = "Staging"
    case Release = "Release"
    
    var baseURL: String {
        switch self {
        case .Development: return "https://start-ios.ngrok.io"
        case .Staging: return "https://staging-api.heroku.com"
        case .Release: return "https://production-api.heroku.com"
        }
    }
}
