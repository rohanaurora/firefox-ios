/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import Shared
import XCTest

// Trivial test for using Deferred.

class DeferredTests: XCTestCase {
    func testDeferred() {
        let d = Deferred<Int>()
        XCTAssertNil(d.peek(), "Value not yet filled.")

        let expectation = expectationWithDescription("Waiting on value.")
        d.upon({ x in
            expectation.fulfill()
        })

        d.fill(5)
        waitForExpectationsWithTimeout(10) { (error) in
            XCTAssertNil(error, "\(error)")
        }

        XCTAssertEqual(5, d.peek()!, "Value is filled.");
    }

    func testMultipleUponBlocks() {
        let e1 = self.expectationWithDescription("First.")
        let e2 = self.expectationWithDescription("Second.")
        let d = Deferred<Int>()
        d.upon { x in
            XCTAssertEqual(x, 5)
            e1.fulfill()
        }
        d.upon { x in
            XCTAssertEqual(x, 5)
            e2.fulfill()
        }
        d.fill(5)
        waitForExpectationsWithTimeout(10, handler: nil)
    }
}
