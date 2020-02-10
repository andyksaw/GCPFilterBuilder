import XCTest
@testable import GCPFilter

final class GCPFilterTests: XCTestCase {
    enum TestField: String {
        case displayName = "display_name"
        case description = "description"
        case userLabels = "user_labels"
    }

    func testAndToken() {
        let query = BuildQuery(for: TestField.self) {
            And {
                Expression(.displayName, .equal, rawValue: "test_name")
                Expression(.description, .equal, rawValue: "test_description")
            }
        }
        XCTAssertEqual(query, "(display_name='test_name' AND description='test_description')")
    }

    static var allTests = [
        ("testAndToken", testAndToken),
    ]
}
