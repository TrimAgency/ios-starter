
import Foundation
import RxSwift

protocol LoginService {
    static func login(with user: User) -> Observable<User>
}
