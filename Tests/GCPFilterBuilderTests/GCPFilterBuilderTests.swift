//
//  GCPFilterBuilderTests.swift
//  GCPFilterBuilder
//
//  Created by Andy Saw on 2020/02/11.
//  Copyright © 2020 Andy Saw. All rights reserved.
//

import XCTest

@testable import GCPFilterBuilder

final class GCPFilterTests: XCTestCase {

    enum TestField: String {
        case displayName = "display_name"
        case description = "description"
        case userLabels = "user_labels"
    }

    static var allTests = [
        ("testAnd", testAnd),
        ("testAndNested", testAndNested),
        ("testOr", testOr),
        ("testOrNested", testOrNested),
    ]

    func testAnd() {
        let query = BuildQuery(for: TestField.self) {
            And {
                Field(.displayName, .equal, rawValue: "test_name")
                Field(.description, .equal, rawValue: "test_description")
            }
        }
        XCTAssertEqual(query, "display_name='test_name' AND description='test_description'")
    }

    func testAndNested() {
        let query = BuildQuery(for: TestField.self) {
            And {
                And {
                    Field(.displayName, .equal, rawValue: "test_name")
                    Field(.description, .equal, rawValue: "test_description")
                }
                Field(.userLabels, .equal, rawValue: "test_user_labels")
            }
        }
        XCTAssertEqual(query, "(display_name='test_name' AND description='test_description') AND user_labels='test_user_labels'")
    }

    func testOr() {
        let query = BuildQuery(for: TestField.self) {
            Or {
                Field(.displayName, .equal, rawValue: "test_name")
                Field(.description, .equal, rawValue: "test_description")
            }
        }
        XCTAssertEqual(query, "display_name='test_name' OR description='test_description'")
    }

    func testOrNested() {
        let query = BuildQuery(for: TestField.self) {
            Or {
                Or {
                    Field(.displayName, .equal, rawValue: "test_name")
                    Field(.description, .equal, rawValue: "test_description")
                }
                Field(.userLabels, .equal, rawValue: "test_user_labels")
            }
        }
        XCTAssertEqual(query, "(display_name='test_name' OR description='test_description') OR user_labels='test_user_labels'")
    }
}
