import Foundation

struct HistoricalData: Decodable, Equatable {
    let data: [HistoricalData.Data]
    
    enum CodingKeys: String, CodingKey {
        case data = "Data"
    }
}

extension HistoricalData {
    struct Data: Decodable, Equatable, Hashable {
        let timestamp: Double
        let open: Double
        let high: Double
        let low: Double
        let close: Double
        
        enum CodingKeys: String, CodingKey {
            case timestamp = "TIMESTAMP"
            case open = "OPEN"
            case high = "HIGH"
            case low = "LOW"
            case close = "CLOSE"
        }
    }
}
