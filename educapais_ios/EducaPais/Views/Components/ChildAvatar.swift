import SwiftUI

struct ChildAvatar: View {
    let name: String
    var size: CGFloat = 48

    var body: some View {
        let letter = name.trimmingCharacters(in: .whitespacesAndNewlines).first.map(String.init) ?? "?"
        Circle()
            .fill(Color(red: 220 / 255, green: 233 / 255, blue: 253 / 255))
            .frame(width: size, height: size)
            .overlay(
                Text(letter.uppercased())
                    .font(.system(size: size * 0.38, weight: .bold))
                    .foregroundStyle(AppColors.primaryBlue)
            )
    }
}
