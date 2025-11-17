import Foundation

protocol LiveUpdateRepositoryProtocol {
    func latestPrice(for currencies: [FiatCurrency]) async throws -> [FiatCurrency: LivePrice]
}
extension LiveUpdateRepositoryProtocol {
    func latestPrice(for currency: FiatCurrency) async throws -> LivePrice? {
        try await latestPrice(for: [currency]).values.first
    }
}

struct LiveUpdateRepository: LiveUpdateRepositoryProtocol {
    private let client: APIClientProtocol

    init(client: APIClientProtocol = APIClient()) {
        self.client = client
    }

    func latestPrice(for currencies: [FiatCurrency]) async throws -> [FiatCurrency : LivePrice] {
        let instruments = currencies.map { "BTC-\($0.rawValue)" }.joined(separator: ",")
        let request = APIRequest<LiveUpdateData>(path: "/latest/tick", query: [
            "market": "cadli",
            "instruments": instruments,
            "apply_mapping": "true"
        ])
        let result = try await client.execute(request)
        var outcome: [FiatCurrency: LivePrice] = [:]
        currencies.forEach { c in
            if let data = result.data["BTC-\(c.rawValue)"] {
                outcome[c] = LivePrice(
                    currency: c,
                    value: data.value,
                    trend: data.valueFlag == .up ? .up : .down,
                    lastUpdateTimestamp: data.valueLastUpdate,
                    lastUpdateQuantity: data.lastUpdateQuantity
                )
            }
        }
        
        return outcome
    }
}
