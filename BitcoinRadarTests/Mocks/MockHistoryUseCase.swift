import Foundation
import XCTest
@testable import BitcoinRadar

struct MockHistoryUseCase: HistoryUseCaseProtocol {
    var result: Result<[HistoryListEntry], Error>

    func fetch() async throws -> [HistoryListEntry] {
        try result.get()
    }
}
