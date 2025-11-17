import Foundation

struct ListViewData: Hashable {
    let date: Date
    let price: String
    let liveUpdate: LiveUpdate?
}
extension ListViewData {
    struct LiveUpdate: Hashable {
        let time: Date
        let price: String
        let flag: Flag
        let changeAmount: String
    }
    
    enum Flag: Hashable {
        case up, down
    }
}

enum ListViewState {
    case loading
    case loaded([ListViewData])
    case error(Error)
}
