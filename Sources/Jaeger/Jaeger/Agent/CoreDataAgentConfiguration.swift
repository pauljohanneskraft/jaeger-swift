//
//  CoreDataAgentConfiguration.swift
//  JaegerTests
//
//  Created by Simon-Pierre Roy on 11/8/18.
//

import Foundation

/**
 The configuration used by the `CoreDataAgent` agent to set up the core data stack and saving behavior.
 */
public struct MemoryAgentConfiguration {

    /**
     Creates a new configuration.
     
     - Parameter averageMaximumSpansPerSecond: The maximum number of spans per seconds to be saved in memory before the next saving operation on disk.
     - Parameter savingInterval: The time between each saving operation on disk.
     - Parameter sendingInterval: The time between each sending tasks to the collector.
     - Parameter errorDelegate: The error delegate. Any core data error or network error will be forwarded to the delegate.
     - Parameter coreDataFolderURL: An optional URL to a folder where the core data files will be saved. When not specified the `NSPersistentContainer.defaultDirectoryURL()` will be used.
     
     - Warning:
     Every parameter should be strictly positive and the sending interval should be greater than the saving interval.
     */
    public init?(
        averageMaximumSpansPerSecond: Int,
        sendingInterval: TimeInterval
        ) {

        guard averageMaximumSpansPerSecond > 0,
            sendingInterval > 0 else {
                return nil
        }

        self.maximumSpansPerSecond = averageMaximumSpansPerSecond
        self.sendingInterval = sendingInterval
        let maxPerSending = (Double(averageMaximumSpansPerSecond) * sendingInterval).rounded(.up)
        self.maximumSpansPerSendingInterval = Int(maxPerSending)
    }

    /// The maximum number of spans per seconds to be saved in memory before the next saving operation on disk.
    public let maximumSpansPerSecond: Int

    /// The time between each sending tasks to the collector.
    public let sendingInterval: TimeInterval


    /// The maximum number of spans fetched from the disk before sending to the collector.
    /// This is the product between the `maximumSpansPerSecond` and the `sendingInterval`.
    public let maximumSpansPerSendingInterval: Int

    public weak var errorDelegate: MemoryAgentErrorDelegate?

}
