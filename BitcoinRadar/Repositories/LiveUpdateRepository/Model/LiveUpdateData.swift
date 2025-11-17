import Foundation

struct LiveUpdateData: Decodable, Equatable {
    let data: [String: PairInfo]
    
    enum CodingKeys: String, CodingKey {
        case data = "Data"
    }
}

extension LiveUpdateData {
    struct PairInfo: Equatable, Decodable {
        let instrument: String
        let value: Double
        let valueFlag: ValueFlag
        let valueLastUpdate: Double
        let lastUpdateQuantity: Double
        
        enum CodingKeys: String, CodingKey {
            case instrument = "INSTRUMENT"
            case value = "VALUE"
            case valueFlag = "VALUE_FLAG"
            case valueLastUpdate = "VALUE_LAST_UPDATE_TS"
            case lastUpdateQuantity = "LAST_UPDATE_QUANTITY"
        }
    }
}

extension LiveUpdateData.PairInfo {
    enum ValueFlag: String, Equatable, Decodable {
        case up = "UP"
        case down = "DOWN"
    }
}
