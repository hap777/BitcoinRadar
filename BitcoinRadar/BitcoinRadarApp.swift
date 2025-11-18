import SwiftUI

@main
struct BitcoinRadarApp: App {
    private let container: DependencyContainer

    init() {
        #if DEBUG
        if let scenario = UITestConfiguration.currentScenario {
            container = UITestDependencyContainer(scenario: scenario)
            return
        }
        #endif
        container = AppDependencyContainer.shared
    }

    var body: some Scene {
        WindowGroup {
            ListView(container: container)
        }
    }
}
