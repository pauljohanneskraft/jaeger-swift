//
//  JSONSenderTests.swift
//  JaegerTests
//
//  Created by Simon-Pierre Roy on 11/8/18.
//

import XCTest
@testable import Jaeger

/*

import CoreData

class JSONSenderTests: XCTestCase {

    func testSendSpansNoError() {

        let urlTest = URL(string: "testURL")!
        let mockSession = URLSessionMock()
        let sender = JSONSender(endPoint: urlTest, session: mockSession)

        let spansSent = XCTestExpectation(description: "sender sent spans")

        let jaegerSpan = JaegerSpan(span: TestUtilities.getNewTestSpan())

        sender.send(spans: [jaegerSpan]) { error in
            XCTAssertNil(error)
            spansSent.fulfill()
        }

        wait(for: [spansSent], timeout: 1)
    }

    func testSendSpansWithError() {

        let urlTest = URL(string: "testURL")!
        let mockSession = URLSessionMock()
        let testError = NSError(domain: "testError", code: -1, userInfo: nil)

        mockSession.error = testError

        let sender = JSONSender(endPoint: urlTest, session: mockSession)

        let spansSent = XCTestExpectation(description: "sender sent spans")
        let jaegerSpan = JaegerSpan(span: TestUtilities.getNewTestSpan())

        sender.send(spans: [jaegerSpan]) { error in
            XCTAssertEqual((error as NSError?), testError)
            spansSent.fulfill()
        }

        wait(for: [spansSent], timeout: 1)
    }

    func testSendSpans() {

        let urlTest = URL(string: "testURL")!
        let mockSession = URLSessionMock()
        let nameId = "test spans"
        let sender = JSONSender(endPoint: urlTest, session: mockSession)

        let spansSent = XCTestExpectation(description: "sender sent spans")
        let sessionDone = XCTestExpectation(description: "session Done")
        let jaegerSpan = JaegerSpan(span: TestUtilities.getNewTestSpan(name: nameId ))

        mockSession.dataTaskExcuted = { resquest in
            guard let data = resquest.httpBody else { return XCTFail("Need Data") }
            guard let spans = try? JSONDecoder().decode([JaegerSpan].self, from: data)  else {
                return XCTFail("Wrong Data")
            }
            XCTAssertEqual(spans.first?.operationName, nameId)
            spansSent.fulfill()
        }

        sender.send(spans: [jaegerSpan]) { _ in
            sessionDone.fulfill()
        }

        wait(for: [spansSent, sessionDone], timeout: 1)
    }
}

 */
