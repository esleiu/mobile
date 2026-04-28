import SwiftUI

struct RootView: View {
    @EnvironmentObject private var session: SessionViewModel

    var body: some View {
        Group {
            if !session.isLoggedIn {
                LoginView()
            } else if session.requiresChildSelection {
                ChildSelectionView()
            } else {
                DashboardView()
            }
        }
        .animation(.easeInOut(duration: 0.24), value: session.isLoggedIn)
        .animation(.easeInOut(duration: 0.24), value: session.requiresChildSelection)
    }
}
