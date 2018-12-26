
import Foundation
import ObjectMapper
import RxSwift
import Alamofire

class MainRequestService {
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
                    case .failure(let error):
                        switch response.response?.statusCode {
                        case 401:
                            observer.onError(ApiError.unauthorized)
                        case 404:
                            observer.onError(ApiError.notFound)
                        case 500:
                            observer.onError(ApiError.internalServerError)
                        default:
                            observer.onError(error)
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
                    case .failure(let error):
                        switch response.response?.statusCode {
                        case 401:
                            observer.onError(ApiError.unauthorized)
                        case 404:
                            observer.onError(ApiError.notFound)
                        case 500:
                            observer.onError(ApiError.internalServerError)
                        default:
                            observer.onError(error)
                        }
                        
                    }
                    
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
