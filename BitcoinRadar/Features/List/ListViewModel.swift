import Combine
import Foundation

@MainActor
final class ListViewModel: ObservableObject {
    @Published var state: ListViewState = .loading
    
    private let useCase: HistoryUseCaseProtocol
    private let priceFormatter: PriceFormatterProtocol
    private var cancellables = Set<AnyCancellable>()

    init(
        useCase: HistoryUseCaseProtocol,
        priceFormatter: PriceFormatterProtocol
    ) {
        self.useCase = useCase
        self.priceFormatter = priceFormatter
    }
    
    func load() async {
        guard case .loading = state else {
            return
        }

        state = .loading
        do {
            let entries = try await useCase.fetch()
            let result = entries.map(makeViewData)
            state = .loaded(result)
            autoRefresh()
        } catch {
            state = .error(error)
        }
    }
    
    func refresh() async {
        guard let entries = try? await useCase.fetch() else { return }
        state = .loaded(entries.map(makeViewData))
    }
    
    private func autoRefresh() {
        Timer.publish(every: 60, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                Task { @MainActor in
                    await self.refresh()
                }
            }
            .store(in: &cancellables)
    }

    private func makeViewData(from entry: HistoryListEntry) -> ListViewData {
        ListViewData(
            date: Date(timeIntervalSince1970: entry.timestamp),
            price: priceFormatter.format(amount: entry.price, currency: .eur),
            liveUpdate: entry.liveUpdate.map(makeLiveUpdateViewData)
        )
    }

    private func makeLiveUpdateViewData(from livePrice: LivePrice) -> ListViewData.LiveUpdate {
        ListViewData.LiveUpdate(
            time: Date(timeIntervalSince1970: livePrice.lastUpdateTimestamp),
            price: priceFormatter.format(amount: livePrice.value, currency: livePrice.currency),
            flag: livePrice.trend == .up ? .up : .down,
            changeAmount: priceFormatter.format(amount: livePrice.lastUpdateQuantity, currency: livePrice.currency, digits: 4)
        )
    }
    
}
