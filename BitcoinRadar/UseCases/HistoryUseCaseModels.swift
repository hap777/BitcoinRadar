import Foundation

struct HistoryListEntry: Equatable {
    let timestamp: TimeInterval
    let price: Double
    let liveUpdate: LivePrice?
}
