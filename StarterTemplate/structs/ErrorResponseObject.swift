
import Foundation

struct ErrorResponseObject: Error {
    var type: ApiResponseType
    var data: ApiResponseData?
}
