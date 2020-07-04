//
//  ErrorHandler.swift
//  Jaeger
//
//  Created by Simon-Pierre Roy on 11/7/18.
//

import Foundation

/// A delegate receiving all errors from a `CoreDataAgent`.
public protocol MemoryAgentErrorDelegate: class {
    /**
     Called every time an error occurred in the `CoreDataAgent`.

     - Parameter error: The internal error.
     
     - Core data errors when saving, fetching and deleting from the underlying context.
     - Networking errors from the sender.
     - Errors from `JSONEncoder`.
     - Errors from `JSONDecoder`.
     */
    func handleError(_ error: Error)
}
