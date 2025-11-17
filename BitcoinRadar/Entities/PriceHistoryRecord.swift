import Foundation

struct PriceHistoryRecord: Equatable, Hashable {
    let timestamp: TimeInterval
    let open: Double
    let high: Double
    let low: Double
    let close: Double
}
