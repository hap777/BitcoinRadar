import SwiftUI

struct LiveUpdateRow: View {
    let viewData: ListViewData.LiveUpdate
    
    private var accessibilityID: String {
        AccessibilityID.List.liveRow(at: viewData.time)
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(viewData.time, style: .time)
                    .font(.headline)
                HStack {
                    Text(viewData.price)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 2) {
                        sign
                        Text(viewData.changeAmount)
                            .font(.caption)
                            .bold()
                            .foregroundStyle(priceColor)
                    }
                }
            }
            
            Spacer()
            
            Text("Live")
                .font(.caption2.bold())
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.green.opacity(0.2))
                .cornerRadius(8)
        }
        .accessibilityIdentifier(accessibilityID)
    }
    
    @ViewBuilder
    private var sign: some View {
        switch viewData.flag {
        case .up:
            Text("+")
                .foregroundStyle(Color.green)
        case .down:
            Text("-")
                .foregroundStyle(Color.red)
        }
    }
    
    private var priceColor: Color {
        switch viewData.flag {
        case .up:
            Color.green
        case .down:
            Color.red
        }
    }
}
