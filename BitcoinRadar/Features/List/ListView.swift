import SwiftUI
import Combine

struct ListView: View {
    @StateObject private var viewModel: ListViewModel
    private let container: DependencyContainer

    init(
        viewModel: ListViewModel? = nil,
        container: DependencyContainer = AppDependencyContainer.shared
    ) {
        self.container = container
        if let viewModel {
            _viewModel = StateObject(wrappedValue: viewModel)
        } else {
            _viewModel = StateObject(wrappedValue: container.makeListViewModel())
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                switch viewModel.state {
                case .loading:
                    ProgressView("Loading…")
                        .accessibilityIdentifier(AccessibilityID.List.loadingIndicator)
                case .loaded(let items):
                    List(items, id: \.self) { item in
                        NavigationLink {
                            PriceDetailView(
                                date: item.date,
                                container: container
                            )
                        } label: {
                            if let liveUpdate = item.liveUpdate {
                                LiveUpdateRow(viewData: liveUpdate)
                            } else {
                                ListRowView(viewData: .init(date: item.date, price: item.price))
                            }
                        }
                        .accessibilityIdentifier(AccessibilityID.List.navigationLink(for: item.date))
                    }
                    .listStyle(.plain)
                    .accessibilityIdentifier(AccessibilityID.List.list)
                case .error(let error):
                    Text(error.localizedDescription)
                        .font(.footnote)
                        .foregroundColor(.red)
                        .padding(8)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                        .padding()
                        .accessibilityIdentifier(AccessibilityID.List.errorMessage)
                }
            }
            .navigationTitle("Bitcoin")
            .navigationBarTitleDisplayMode(.automatic)
            .task {
                await viewModel.load()
            }
        }
    }
}
