import Foundation
import UIKit

struct Configuration {
    lazy var environment: Constants =  {
        let configuration = Bundle.main.object(forInfoDictionaryKey: "Configuration") as! String
        return Constants(rawValue: configuration)!
    }()
}
