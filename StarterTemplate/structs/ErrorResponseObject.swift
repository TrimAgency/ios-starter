
import Foundation

struct ErrorResponseObject: Error {
    var type: ApiErrorType
    var data: ApiErrorData?
}
