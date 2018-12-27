
import Foundation
import RxSwift

protocol LoginService {
    func login(with user: User) -> Observable<LoginResponse>
    func saveJWT(for: String) -> Void
}
