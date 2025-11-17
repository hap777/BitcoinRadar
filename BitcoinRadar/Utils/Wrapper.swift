import Foundation

final class Wrapper<T>: NSObject {
    let value: T
    init(_ value: T) {
        self.value = value
    }
}
