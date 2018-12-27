
import Foundation

// add additional error types that
// the API could return, Usually found
// in exceptions.rb in API
enum ApiErrorType: Error {
    case notFound
    case badRequest
    case unauthorized
    case internalServerError
    case recordInvalid
    case unknown
}
