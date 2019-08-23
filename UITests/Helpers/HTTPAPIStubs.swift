import Foundation
import Swifter

enum HTTPMethod {
    case POST
    case GET
}

class HTTPApiStubs {
    
    var server = HttpServer()
    
    func setUp() {
        setupInitialStubs()
        try! server.start()
    }
    
    func tearDown() {
        server.stop()
    }
    
    func setupInitialStubs() {
        for stub in initialStubs {
            setupStub(url: stub.url, filename: stub.jsonFilename, method: stub.method)
        }
    }
    
    public func setupStub(url: String, filename: String, method: HTTPMethod = .GET) {
        let testBundle = Bundle(for: HTTPApiStubs.self)
        let filePath = testBundle.path(forResource: filename, ofType: "json")
        let fileUrl = URL(fileURLWithPath: filePath!)
        
        let data = try! Data(contentsOf: fileUrl, options: .uncached)
        
        let json = dataToJSON(data: data)
        
        let response: ((HttpRequest) -> HttpResponse) = { _ in
            return HttpResponse.ok(.json(json as AnyObject))
        }
        
        switch method  {
        case .GET : server.GET[url] = response
        case .POST: server.POST[url] = response
        }
    }
    
    func dataToJSON(data: Data) -> Any? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil
    }
}

struct HTTPStubInfo {
    let url: String
    let jsonFilename: String
    let method: HTTPMethod
}

let initialStubs: [HTTPStubInfo] = [
    // Example stub, if you need certain stubs always available
    // HTTPStubInfo(url: "/api/user_token", jsonFilename: "login_success", method: .POST),
]
