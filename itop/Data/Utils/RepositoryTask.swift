//
//  DataTransfer.swift
//  iTOP
//
//  Created by meganathan on 20 Jul 2020.
//

import Foundation

class RepositoryTask: Cancellable {
    var networkTask: NetworkCancellable?
    var isCancelled: Bool = false
    
    func cancel() {
        networkTask?.cancel()
        isCancelled = true
    }
}
