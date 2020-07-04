//
//  CoreDataAgent.swift
//  Jaeger
//
//  Created by Simon-Pierre Roy on 11/6/18.
//

import Foundation

/// An agent using a Core Data Stack to save a binary representation of a JaegerSpan.
public typealias JaegerAgent = MemoryAgent<JaegerSpan>

/**
 Constants for the CoreDataAgent.
 */
private enum Constants {
    /// The shared `JSONEncoder`.
    static let jsonEncoder =  JSONEncoder()
    /// The shared `JSONDecoder`.
    static let jsonDecoder =  JSONDecoder()
}

/**
 An agent using a Core Data Stack to save a binary representation of a span. The agent will save the spans periodically on disk in order to minimize the memory footprint  and optimize disk writing operations. At regular intervals, spans will be fetched from the disk and send to the provided `SpanSender`.
 
 A SQLite store type is used for the persistent store.
 */
public final class MemoryAgent<RawSpan: SpanConvertible>: Agent {

    /// The point of entry to report spans to a collector.
    public let spanSender: SpanSender

    /// The configuration applied to this instance.
    private let config: MemoryAgentConfiguration

    private var spans = [Span]()

    /// The timer used to execute fetching and sending tasks.
    private weak var sendingTimer: Timer?

    /**
     Creates a new agent from a specified configuration and a core data stack.
     
     - Parameter config: The configuration for the core data stack and agent.
     - Parameter sender: The point of entry to report spans to a collector.
     - Parameter stack: The core data stack.
     - Parameter reachabilityTracker: The tracker used to monitor network accessibility.
     */
    init(
        config: MemoryAgentConfiguration,
        sender: SpanSender
    ) {

        self.config = config
        self.spanSender = sender

        sendingTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(self.config.sendingInterval), repeats: true) { [weak self] _ in
            self?.executeSendingTasks()
        }

        executeSendingTasks() // Send cached data from the last app start.
    }

    /**
     This function adds and saves the span locally.
     
     - Parameter span: A Span sent by the tracer.
     
     If the maximum threshold is exceeded  for the current saving period, then the span will be ignored.
     */
    public func record(span: Span) {
        spans.append(span)
    }

    /// Call this to fetch and send spans to the collector. (thread safe)
    private func executeSendingTasks() {
        sendAllSavedSpans()
    }

    /**
     It will fetch all spans when the network is available and it will forward the data to the `SpanSender`.
     
     - Warning:
     Only call this method from the `backgroundContext` queue.
     */
    private func sendAllSavedSpans() {
        let values = spans.prefix(config.maximumSpansPerSendingInterval)
        guard values.count > 0  else { return }
        handle(results: Array(values))
    }

    /**
     It will map the core data spans to the original object, delete all data in the persistent store and forward the data to the `SpanSender`.
     
     - Parameter results: A list of core data spans.
     
     - Warning:
     Only call this method from the `backgroundContext` queue.
     */
    private func handle(results: [Span]) {
        let spans: [RawSpan] = results.map(RawSpan.convert)

        deleteAllSpans()

        guard spans.count > 0 else { return }

        self.spanSender.send(spans: spans) { [weak self] error in
            guard let error = error else { return }
            self?.config.errorDelegate?.handleError(error)
        }
    }

    /**
     Delete all data in the persistent store. It will create a delete request according to the store type.
     
     - Warning:
     Only call this method from the `backgroundContext` queue.
     */
    private func deleteAllSpans() {
        spans.removeAll(keepingCapacity: true)
    }

    ///  :nodoc:
    deinit {
        sendingTimer?.invalidate()
    }

}
