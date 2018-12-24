
import Foundation

// add additional error types that
// the API could return, Usually found
// in exceptions.rb in API
enum ApiError: Error {
    case notFound
    case unauthorized
    case internalServerError
    case recordInvalid
}
