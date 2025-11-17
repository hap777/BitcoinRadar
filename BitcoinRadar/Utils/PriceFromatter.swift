import Foundation

protocol PriceFormatterProtocol {
    func format(amount: Double, currency: FiatCurrency, digits: Int) -> String
}
extension PriceFormatterProtocol {
    func format(amount: Double, currency: FiatCurrency) -> String {
        format(amount: amount, currency: currency, digits: 2)
    }
}

struct PriceFormatter: PriceFormatterProtocol {
    func format(amount: Double, currency: FiatCurrency, digits: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currency.rawValue
        formatter.locale = Locale.current
        formatter.maximumFractionDigits = digits

        if let currencyString = formatter.string(from: NSNumber(value: amount)) {
            return currencyString
        }
        
        return "N/A"
    }
}
