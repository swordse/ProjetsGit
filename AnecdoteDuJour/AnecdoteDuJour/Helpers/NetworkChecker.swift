//
//  NetworkChecker.swift
//  AnecdoteDuJour
//
//  Created by Raphaël Goupille on 13/02/2023.
//

import Foundation
import Network

class NetworkChecker: ObservableObject {
    
    private let networkChecker = NWPathMonitor()
    private let networkQueue = DispatchQueue(label: "Monitor")
    var isConnected = false
    
    init() {
        networkChecker.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied
            Task {
                await MainActor.run(body: {
                    self.objectWillChange.send()
                })
            }
        }
        networkChecker.start(queue: networkQueue)
    }
}
