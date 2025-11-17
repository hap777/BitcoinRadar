import Foundation

protocol HistoryUseCaseProtocol {
    func fetch() async throws -> [HistoryListEntry]
}

struct HistoryUseCase: HistoryUseCaseProtocol {
    let historyRepository: HistoryRepositoryProtocol
    let liveUpdateRepository: LiveUpdateRepositoryProtocol
    
    init(
        historyRepository: HistoryRepositoryProtocol,
        liveUpdateRepository: LiveUpdateRepositoryProtocol
    ) {
        self.historyRepository = historyRepository
        self.liveUpdateRepository = liveUpdateRepository
    }
    
    func fetch() async throws -> [HistoryListEntry] {
        async let historicalEUR = historyRepository.history(for: .eur)
        async let liveEUR = liveUpdateRepository.latestPrice(for: .eur)
        
        let (histories, liveUpdate) = try await (historicalEUR, liveEUR)

        var entries: [HistoryListEntry] = []
        var hasTodayEntry = false

        for item in histories {
            let isTodayEntry = isToday(timestamp: item.timestamp)
            if isTodayEntry {
                hasTodayEntry = true
            }
            let entry = HistoryListEntry(
                timestamp: item.timestamp,
                price: item.close,
                liveUpdate: isTodayEntry ? liveUpdate : nil
            )
            entries.append(entry)
        }

        if let liveUpdate, hasTodayEntry == false {
            let todayEntry = HistoryListEntry(
                timestamp: liveUpdate.lastUpdateTimestamp,
                price: liveUpdate.value,
                liveUpdate: liveUpdate
            )
            entries.append(todayEntry)
        }

        return entries.sorted(by: { $0.timestamp > $1.timestamp })
    }
    
    func isToday(timestamp: Double) -> Bool {
        let date = Date(timeIntervalSince1970: timestamp)

        let calendar = Calendar.current
        let now = Date()

        let startOfDay = calendar.startOfDay(for: now)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!

        let isToday = (date >= startOfDay && date < endOfDay)
        return isToday
    }
}
