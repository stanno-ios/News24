//
//  ConnectionHandler.swift
//  SpacenewsReader
//
//  Created by Stanislav Rassolenko on 8/30/22.
//

import UIKit
import Network
import WebKit

/// class ConnectionHandler is responsible for managing internet connection and handling "no connection" situations

class ConnectionHandler {
    
    static let shared: ConnectionHandler = ConnectionHandler()
    private var reconnected = false
    
    func monitorConnection<T: UIView>(views: [T], webViewUrl: URL? = nil) {
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: Strings.queueLabel)
        monitor.pathUpdateHandler = { handler in
            if handler.status == .satisfied {
                DispatchQueue.main.async {
                    self.toggleVisibility(connected: true, views: views, webViewUrl: webViewUrl)
                }
            } else {
                DispatchQueue.main.async {
                    self.toggleVisibility(connected: false, views: views, webViewUrl: webViewUrl)
                }
            }
        }
        monitor.start(queue: queue)
    }
    
    
    private func toggleVisibility<T: UIView>(connected: Bool, views: [T], webViewUrl: URL? = nil) {
        for view in views {
            if let view = view as? UICollectionView {
                view.isHidden = !connected
            } else {
                view.isHidden = connected
            }
            
            if let view = view as? WKWebView {
                view.isHidden = !connected
                if connected {
                    guard let webViewUrl = webViewUrl else {
                        return
                    }
                    view.load(URLRequest(url: webViewUrl))
                    view.allowsBackForwardNavigationGestures = true
                }
            }
            
            if let view = view as? NoConnectionView {
                connected ? view.connectingActivityIndicator.stopAnimating() : view.connectingActivityIndicator.startAnimating()
            }
            
            if let view = view as? UIActivityIndicatorView {
                    view.isHidden = !connected

                    if connected {
                        view.startAnimating()
                    }
                    
                    if self.reconnected {
                        view.stopAnimating()
                    }
            }
        }
        self.reconnected = true
    }
}
