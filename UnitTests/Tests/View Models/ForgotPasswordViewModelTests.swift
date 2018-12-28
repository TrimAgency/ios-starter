import XCTest
import RxTest
import RxSwift
import RxCocoa
import RxBlocking
@testable import StarterTemplate

class ForgotPasswordViewModelTests: XCTestCase {
    
    // Mock injected service
    private class MockUserService: ForgotPasswordService {
        func forgotPassword(with user: User) -> Observable<User> {
            let response = User()
            
            return Observable.just(response)
        }
    }
    
    var viewModel: ForgotPasswordViewModel!
    var scheduler: SchedulerType!
    
    override func setUp() {
        super.setUp()
        let userService = MockUserService()
        scheduler = ConcurrentDispatchQueueScheduler(qos: .default)
        viewModel = ForgotPasswordViewModel(userService: userService)
    }
    
    override func tearDown() {
        super.setUp()
    }
    
    func testValidatesForm_with_good_data() {
        viewModel.emailViewModel.data.accept("test@testing.com")
        
        let formValid = viewModel.validateFields()
        
        XCTAssertTrue(formValid)
    }
    
    func testValidatesForm_with_bad_email() {
        viewModel.emailViewModel.data.accept("test@testing")
        
        let formValid = viewModel.validateFields()
        
        XCTAssertFalse(formValid)
    }
    
    func testForgotPassword() {
        viewModel.emailViewModel.data.accept("test@testing.com")
        
        viewModel.forgotPassword()
        
        XCTAssertTrue(viewModel.success.value)
    }
}
