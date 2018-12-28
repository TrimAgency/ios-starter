
import Foundation
import ObjectMapper
import RxSwift
import Alamofire

class MainRequestService {
    var errorData: ApiResponseData?
    
    func newRequestWithKeyPath<T: Mappable> (route: URLRequestConvertible, keypath: String) -> Observable<T> {
        return Observable<T>.create { observer in
            let request = APIClient.session
                .request(route)
                .validate()
                .responseObject(keyPath: keypath) { (response: DataResponse<T>) in
                    switch response.result {
                    case .success(let value):
                        observer.onNext(value)
                        observer.onCompleted()
                    case .failure(_):
                        if let data = response.data {
                          let decoder = JSONDecoder()
                          self.errorData = try! decoder.decode(ApiResponseData.self, from: data)
                        }
                        switch response.response?.statusCode {
                        case 400:
                            let errorObject = ErrorResponseObject(type: ApiResponseType.badRequest, data: self.errorData)
                            
                            observer.onError(errorObject)
                        case 401:
                            let errorObject = ErrorResponseObject(type: ApiResponseType.unauthorized, data: self.errorData)
                            observer.onError(errorObject)
                        case 404:
                            let errorObject = ErrorResponseObject(type: ApiResponseType.notFound, data: self.errorData)
                            observer.onError(errorObject)
                        case 500:
                            let errorObject = ErrorResponseObject(type: ApiResponseType.internalServerError, data: self.errorData)
                            observer.onError(errorObject)
                        default:
                            let errorObject = ErrorResponseObject(type: ApiResponseType.unknown, data: self.errorData)
                            observer.onError(errorObject)
                        }
                        
                    }
                    
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    func newRequestWithoutKeyPath<T: Mappable> (route: URLRequestConvertible) -> Observable<T> {
        return Observable<T>.create { observer in
            let request = APIClient.session
                .request(route)
                .validate()
                .responseObject { (response: DataResponse<T>) in
                    switch response.result {
                    case .success(let value):
                        observer.onNext(value)
                        observer.onCompleted()
                    case .failure(_):
                        if let data = response.data {
                            let decoder = JSONDecoder()
                            self.errorData = try! decoder.decode(ApiResponseData.self, from: data)
                        }
                        switch response.response?.statusCode {
                        case 401:
                            let errorObject = ErrorResponseObject(type: ApiResponseType.unauthorized, data: self.errorData)
                            observer.onError(errorObject)
                        case 404:
                            let errorObject = ErrorResponseObject(type: ApiResponseType.notFound, data: self.errorData)
                            observer.onError(errorObject)
                        case 500:
                            let errorObject = ErrorResponseObject(type: ApiResponseType.internalServerError, data: self.errorData)
                            observer.onError(errorObject)
                        default:
                            let errorObject = ErrorResponseObject(type: ApiResponseType.unknown, data: self.errorData)
                            observer.onError(errorObject)
                        }
                        
                    }
                    
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
