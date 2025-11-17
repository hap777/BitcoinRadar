import SwiftUI

struct PriceDetailView: View {
    let date: Date
    
    @StateObject private var viewModel: PriceDetailViewModel
    
    init(
        date: Date,
        container: DependencyContainer = AppDependencyContainer.shared
    ) {
        self.date = date
        _viewModel = StateObject(
            wrappedValue: container.makePriceDetailViewModel(for: date)
        )
    }
    
    var body: some View {
        VStack(spacing: 24) {
            Text(date, style: .date)
                .font(.title2.bold())
                .padding(.top, 16)
            
            Group {
                switch viewModel.state {
                case .loading:
                    ProgressView()
                        .accessibilityIdentifier(AccessibilityID.Detail.loadingIndicator)
                case .loaded(let detail):
                        VStack(spacing: 12) {
                            priceRow(label: FiatCurrency.eur.rawValue, price: detail.eur)
                            priceRow(label: FiatCurrency.usd.rawValue, price: detail.usd)
                            priceRow(label: FiatCurrency.gbp.rawValue, price: detail.gbp)
                        }
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(16)
                        .shadow(radius: 2)
                        .accessibilityElement(children: .contain)
                        .accessibilityIdentifier(AccessibilityID.Detail.container)
                case .error:
                    Text("error")
                        .foregroundColor(.red)
                        .accessibilityIdentifier(AccessibilityID.Detail.errorMessage)
                }
            }
            Spacer()
        }
        .padding(.horizontal)
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.load()
        }
    }
    
    private func priceRow(label: String, price: String) -> some View {
        return HStack {
            Text(label)
                .font(.headline)
            Spacer()
            
            Text(price)
                .font(.body.monospacedDigit())
        }
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier(AccessibilityID.Detail.priceRow(code: label))
    }
}
