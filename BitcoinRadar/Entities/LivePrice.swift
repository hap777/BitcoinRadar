import Foundation

struct LivePrice: Equatable {
    enum Trend: Equatable {
        case up
        case down
    }

    let currency: FiatCurrency
    let value: Double
    let trend: Trend
    let lastUpdateTimestamp: TimeInterval
    let lastUpdateQuantity: Double
}
