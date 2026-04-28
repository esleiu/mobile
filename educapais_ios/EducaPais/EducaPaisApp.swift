import SwiftUI

@main
struct EducaPaisApp: App {
    @StateObject private var session = SessionViewModel()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(session)
                .preferredColorScheme(.light)
        }
    }
}
