import Foundation

enum DetailViewState {
    case loading
    case loaded(DetailViewData)
    case error
}

struct DetailViewData: Equatable {
    let date: Date
    let eur: String
    let usd: String
    let gbp: String
}
