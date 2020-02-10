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
                Expression(.displayName, .equal, rawValue: "test_name")
                Expression(.description, .equal, rawValue: "test_description")
            }
        }
        XCTAssertEqual(query, "display_name='test_name' AND description='test_description'")
    }

    func testAndNested() {
        let query = BuildQuery(for: TestField.self) {
            And {
                And {
                    Expression(.displayName, .equal, rawValue: "test_name")
                    Expression(.description, .equal, rawValue: "test_description")
                }
                Expression(.userLabels, .equal, rawValue: "test_user_labels")
            }
        }
        XCTAssertEqual(query, "(display_name='test_name' AND description='test_description') AND user_labels='test_user_labels'")
    }

    func testOr() {
        let query = BuildQuery(for: TestField.self) {
            Or {
                Expression(.displayName, .equal, rawValue: "test_name")
                Expression(.description, .equal, rawValue: "test_description")
            }
        }
        XCTAssertEqual(query, "display_name='test_name' OR description='test_description'")
    }

    func testOrNested() {
        let query = BuildQuery(for: TestField.self) {
            Or {
                Or {
                    Expression(.displayName, .equal, rawValue: "test_name")
                    Expression(.description, .equal, rawValue: "test_description")
                }
                Expression(.userLabels, .equal, rawValue: "test_user_labels")
            }
        }
        XCTAssertEqual(query, "(display_name='test_name' OR description='test_description') OR user_labels='test_user_labels'")
    }
}
