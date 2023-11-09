//
//  Network.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 9/13/23.
//

import Network
import UIKit

class Network: NSObject {
    let monitor = NWPathMonitor()
    private var status: NWPath.Status = .requiresConnection
    var hasConnection: Bool = false

    static let shared = Network()
    
    override init() {
        super.init()
        
        monitorNetwork()
    }
    
    func monitorNetwork() {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                // connected
                self.hasConnection = true
            } else {
                // no connection
                self.hasConnection = false
            }
        }

        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
}
