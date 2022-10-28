//
//  DataTransferError.swift
//  itop
//
//  Created by meganathan on 21/07/22.
//


import Foundation

extension DataTransferError: ConnectionError {
    public var isInternetConnectionError: Bool {
        guard case let DataTransferError.networkFailure(networkError) = self,
            case .notConnected = networkError else {
                return false
        }
        return true
    }
}
