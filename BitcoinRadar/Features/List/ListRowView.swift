import SwiftUI

struct ListRowData {
    let date: Date
    let price: String
}

struct ListRowView: View {
    let viewData: ListRowData

    private var accessibilityID: String {
        AccessibilityID.List.historyRow(date: viewData.date)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(viewData.date, style: .date)
                .font(.headline)
            Text(viewData.price)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .accessibilityIdentifier(accessibilityID)
    }
}
