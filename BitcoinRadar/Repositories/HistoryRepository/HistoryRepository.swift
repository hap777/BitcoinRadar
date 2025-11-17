import Foundation

protocol HistoryRepositoryProtocol {
    func history(for currency: FiatCurrency) async throws -> [PriceHistoryRecord]
}

struct HistoryRepository: HistoryRepositoryProtocol {
    let client: APIClientProtocol
    let cache = NSCache<NSString, Wrapper<[PriceHistoryRecord]>>()

    init(client: APIClientProtocol = APIClient()) {
        self.client = client
    }
    
    func history(for currency: FiatCurrency) async throws -> [PriceHistoryRecord] {
        let request = APIRequest<HistoricalData>(path: "historical/days", query: [
            "market": "cadli",
            "instrument": "BTC-\(currency.rawValue)",
            "limit": "14",
            "response_format": "JSON"
        ])
        if let cached = cache.object(forKey: key(for: request)) {
            return cached.value
        }
        let result = try await client.execute(request)
        let records = result.data.map { data in
            PriceHistoryRecord(
                timestamp: data.timestamp,
                open: data.open,
                high: data.high,
                low: data.low,
                close: data.close
            )
        }
        cache.setObject(Wrapper(records), forKey: key(for: request))
        return records
    }
    
    func key(for request: APIRequest<HistoricalData>) -> NSString {
        let sortedQuery = request.query
            .sorted(by: { $0.key < $1.key })
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
        let keyString: String
        if sortedQuery.isEmpty {
            keyString = request.path
        } else {
            keyString = "\(request.path)?\(sortedQuery)"
        }
        return keyString as NSString
    }
}
