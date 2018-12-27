import Foundation
import RxSwift

protocol SignupService {
    func signUp(with user: User) -> Observable<User>
}
