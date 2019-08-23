import XCTest

class LoginTest: XCTestCase {
    
    let testApp = XCUIApplication()
    let apiStubs = HTTPApiStubs()
    
    override func setUp() {
        apiStubs.setUp()
        apiStubs.setupStub(url: "/api/user_token", filename: "login_success", method: .POST)
        testApp.launchEnvironment = ["BASEURL" : "http://localhost:8080"]
        continueAfterFailure = false
        
    }
    
    override func tearDown() {
        apiStubs.tearDown()
    }
    
    func testLoginSuccess() {
        let email = "test@tester.com"
        let password = "password"
        
        testApp.launch()
        XCUIApplication().buttons["login"].tap()
        let emailField = testApp.textFields["Enter email here"].waitForExistence(timeout: 2)
        
        if emailField {
            testApp.textFields["Enter email here"].tap()
            testApp.textFields["Enter email here"].typeText(email)
            
            testApp.textFields["Enter password here"].tap()
            testApp.textFields["Enter password here"].typeText(password)
            
            testApp.buttons["login"].tap()
            
            let successMessageExists = testApp.alerts["Success"].waitForExistence(timeout: 2)
            XCTAssert(successMessageExists)
        } else {
            fatalError()
        }
    }
}
