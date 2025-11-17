import Foundation

struct DailyMultiCurrencyPrice: Equatable {
    let date: Date
    let eur: Double
    let usd: Double
    let gbp: Double
}
