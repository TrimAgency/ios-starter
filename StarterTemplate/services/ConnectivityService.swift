//
//  ConnectivityService.swift
//  StarterTemplate
//
//  Created by Dominique Miller on 8/23/19.
//  Copyright © 2019 Trim Agency. All rights reserved.
//

import Foundation
import Alamofire

class ConnectivityService {
    
    static let shared = ConnectivityService()
    
    private init() {}
    
    let networkManager = Alamofire.NetworkReachabilityManager(host: "www.apple.com")
    
    var isConnectedToInternet: Bool {
        guard let network = networkManager else { return false }
        return network.isReachable
    }
    
    func startListeningForNetworkChanges() {
        networkManager?.listener = { status in
            switch status {
            case .notReachable:
                self.sendNotification(status: false)
            case .reachable:
                self.sendNotification(status: true)
            case .unknown:
                self.sendNotification(status: false)
            }
        }
        
        networkManager?.startListening()
    }
    
    private func sendNotification(status: Bool) {
        NotificationCenter.default.post(name: .NetworkStatusChanged,
                                        object: nil,
                                        userInfo: [ "isConnectedToNetwork": status ])
    }
}
