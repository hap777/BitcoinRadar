# BitcoinRadar

BitcoinRadar is a SwiftUI application that displays historical and live Bitcoin prices in multiple fiat currencies. It demonstrates a clean architecture approach with repositories, use cases, and presentation layers wired through a lightweight dependency factory.

## Project Highlights
- **SwiftUI UI** for the list of historical prices and per-day detail view with EUR/USD/GBP conversions.
- **Combine/async-await** based data flow with `HistoryRepository`, `LiveUpdateRepository`, and use cases for history/detail retrieval.
- **Custom dependency factories** (`Dependencies` in `BitcoinRadar/Utils/Dependencies.swift`).
- **UITests** exercising the main flows through deterministic stubs activated by the `UITEST_SCENARIO` launch environment.
- **Accessibility identifiers** across the UI to make UITests stable irrespective of locale/time changes.

## Requirements
- Xcode 15.4 or later (built with the Xcode 15 toolchain / iOS 15 SDK).
- iOS 15 simulator or device for running the app.
- Swift Package Manager is not required beyond what ships with Xcode (no external dependencies).

## Running the App
1. Open `BitcoinRadar.xcodeproj` in Xcode.
2. Select the `BitcoinRadar` scheme and choose an iOS 15+ simulator/device.
3. Build & run (`⌘R`). The list view will fetch historical data and show live updates for the current day.

## Running Tests
### Unit Tests
1. Select the `BitcoinRadar` scheme.
2. Choose `Product > Test` (`⌘U`) or run `xcodebuild test -scheme BitcoinRadar -destination 'platform=iOS Simulator,name=iPhone 15'`.

### UI Tests
1. Still under the `BitcoinRadar` scheme, ensure the UITest target is enabled in the test navigator.
2. Run the UITest bundle (`BitcoinRadarUITests`). The tests automatically set the `UITEST_SCENARIO` environment and the app switches to stubbed dependencies via `UITestFactoryConfigurator`.

## Architecture Overview
```
SwiftUI Views <-> ViewModels <-> UseCases <-> Repositories <-> APIClient
```
- `Features/List` and `Features/Detail` contain the SwiftUI presentation layers.
- `UseCases/HistoryUseCase.swift` and `UseCases/DayDetailUseCase.swift` encapsulate business logic.
- `Repositories` talk to the network through `APIClient`.
- `Dependencies.swift` exposes factories for repositories/use cases/view models.

## Notes
- The UITests rely on the accessibility identifiers defined in `AccessibilityIdentifiers.swift`.
- To run the app with real data outside of tests, simply launch without the `UITEST_SCENARIO` environment variable.
