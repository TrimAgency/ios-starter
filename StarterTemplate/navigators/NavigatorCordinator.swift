
import Foundation
import UIKit

class NavigatorCordinator {
    
    private var navigationController: UINavigationController?
    
    init(navController: UINavigationController) {
        navigationController = navController
    }
    
    func navigate(to destination: Destination) {
        let viewController = destination.controller
        navigationController?.pushViewController(viewController,
                                                 animated: true)
    }
}

