import Foundation
import XCTest
@testable import BitcoinRadar

final class MockAPIClient: APIClientProtocol {
    var executeCallCount = 0
    var response: Any?
    var error: Error?

    func execute<Response>(_ request: APIRequest<Response>) async throws -> Response where Response : Decodable {
        executeCallCount += 1
        if let error {
            throw error
        }
        guard let response = response as? Response else {
            XCTFail("Response \(String(describing: self.response)) is not of expected type \(Response.self)")
            throw NSError(domain: "MockAPIClient", code: 0)
        }
        return response
    }
}
