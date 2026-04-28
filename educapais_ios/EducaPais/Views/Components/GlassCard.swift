import SwiftUI

struct GlassCard<Content: View>: View {
    @ViewBuilder var content: Content

    var body: some View {
        content
            .padding(14)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(Color.white.opacity(0.55), lineWidth: 0.9)
            )
            .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 7)
    }
}
