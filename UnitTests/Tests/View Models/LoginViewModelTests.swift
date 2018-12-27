import XCTest
import RxTest
import RxSwift
import RxCocoa
import RxBlocking
@testable import StarterTemplate

class LoginViewModelTests: XCTestCase {
    
    // Mock injected service
    private class MockUserService: LoginService {
        var saveJWTgotCalled = false
        func login(with user: User) -> Observable<LoginResponse> {
            let response = LoginResponse()
            response.jwt = "testJWT1234658686jfjskjhkadhjf"
            
        return Observable.just(response)
        }
        
        func saveJWT(for jwt:String) {
            saveJWTgotCalled = true
        }
    }
    
    var viewModel: LoginViewModel!
    var scheduler: SchedulerType!

    override func setUp() {
        super.setUp()
        let userService = MockUserService()
        scheduler = ConcurrentDispatchQueueScheduler(qos: .default)
        viewModel = LoginViewModel(userService: userService)
    }

    override func tearDown() {
        super.setUp()
    }

    func testValidatesForm_with_good_data() {
        viewModel.emailViewModel.data.accept("test@testing.com")
        viewModel.passwordVieModel.data.accept("password")
        
        let formValid = viewModel.validateFields()
        
        XCTAssertTrue(formValid)
    }
    
    func testValidatesForm_with_bad_email() {
        viewModel.emailViewModel.data.accept("test@testing")
        viewModel.passwordVieModel.data.accept("password")
        
        let formValid = viewModel.validateFields()
        
        XCTAssertFalse(formValid)
    }
    
    func testValidatesForm_with_bad_password() {
        viewModel.emailViewModel.data.accept("test@testing.com")
        viewModel.passwordVieModel.data.accept("pass")
        
        let formValid = viewModel.validateFields()
        
        XCTAssertFalse(formValid)
    }
    
    func testLogin() {
        viewModel.emailViewModel.data.accept("test@testing.com")
        viewModel.passwordVieModel.data.accept("password")
        
        viewModel.login()
        
        XCTAssertTrue(viewModel.success.value)
        XCTAssertEqual(viewModel.user.email, "test@testing.com")
        XCTAssertEqual(viewModel.user.password, "password")
    }
    
    func testLogin_saves_jwt() {
        viewModel.emailViewModel.data.accept("test@testing.com")
        viewModel.passwordVieModel.data.accept("password")
        
        viewModel.login()
        if let jwt = KeychainService.getUserJWT() {
            XCTAssertEqual(jwt, "testJWT1234658686jfjskjhkadhjf")
        }
    }
}
