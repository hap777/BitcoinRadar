import Foundation

enum AccessibilityID {
    enum List {
        static let loadingIndicator = "list_loading_indicator"
        static let list = "history_list"
        static let errorMessage = "list_error_message"

        static func historyRow(date: Date) -> String {
            "list_row_\(Int(date.timeIntervalSince1970))"
        }

        static func liveRow(at time: Date) -> String {
            "list_live_row_\(Int(time.timeIntervalSince1970))"
        }

        static func navigationLink(for date: Date) -> String {
            "list_row_link_\(Int(date.timeIntervalSince1970))"
        }
    }

    enum Detail {
        static let loadingIndicator = "detail_loading_indicator"
        static let errorMessage = "detail_error_message"
        static let container = "detail_prices_container"

        static func priceRow(code: String) -> String {
            "detail_price_row_\(code)"
        }
    }
}
