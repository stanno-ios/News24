//
//  ConnectionHandler.swift
//  SpacenewsReader
//
//  Created by Stanislav Rassolenko on 8/30/22.
//

import UIKit
import Network

class ConnectionHandler {
    
    static let shared: ConnectionHandler = ConnectionHandler()
    
    func monitorConnection<T: UIView>(views: [T]) {
        
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "InternetConnectionMonitor")
        monitor.pathUpdateHandler = { handler in
            if handler.status == .satisfied {
                DispatchQueue.main.async {
                    self.toggleVisibility(connected: true, views: views)
                }
            } else {
                DispatchQueue.main.async {
                    self.toggleVisibility(connected: false, views: views)
                }
            }
        }
        monitor.start(queue: queue)
    }
    
    
    func toggleVisibility<T: UIView>(connected: Bool, views: [T]) {
        for view in views {
            
            if let view = view as? UICollectionView {
                view.isHidden = !connected
            } else {
                view.isHidden = connected
            }
            
            if let view = view as? UIActivityIndicatorView {
                view.tag == 0 ? (connected ? view.stopAnimating() : view.startAnimating()) : view.startAnimating()
            }
        }
    }
}
