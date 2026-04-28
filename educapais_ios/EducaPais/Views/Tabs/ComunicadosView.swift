import SwiftUI

struct ComunicadosView: View {
    let filho: Filho

    private var sortedComunicados: [Comunicado] {
        filho.comunicados.sorted { lhs, rhs in
            let left = lhs.data ?? .distantPast
            let right = rhs.data ?? .distantPast
            return left > right
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("Comunicados")
                    .font(.title3.bold())
                    .foregroundStyle(AppColors.textPrimary)

                if sortedComunicados.isEmpty {
                    GlassCard {
                        HStack(spacing: 10) {
                            Image(systemName: "info.circle")
                                .foregroundStyle(AppColors.textSecondary)
                            Text("Nenhum comunicado para este aluno no momento.")
                                .font(.subheadline)
                                .foregroundStyle(AppColors.textSecondary)
                            Spacer()
                        }
                    }
                } else {
                    ForEach(sortedComunicados) { comunicado in
                        ComunicadoCard(comunicado: comunicado)
                    }
                }
            }
            .padding(16)
            .padding(.bottom, 24)
        }
        .scrollIndicators(.hidden)
    }
}

private struct ComunicadoCard: View {
    let comunicado: Comunicado

    private var style: (icon: String, border: Color, background: Color, accent: Color) {
        let normalized = comunicado.tipo.lowercased()
        if normalized.contains("prova") {
            return ("square.and.pencil", Color(red: 247 / 255, green: 231 / 255, blue: 193 / 255), Color(red: 255 / 255, green: 246 / 255, blue: 227 / 255), AppColors.warning)
        }
        if normalized.contains("reuni") {
            return ("person.3", Color(red: 220 / 255, green: 232 / 255, blue: 251 / 255), Color(red: 237 / 255, green: 244 / 255, blue: 255 / 255), AppColors.accentBlue)
        }
        if normalized.contains("aviso") {
            return ("bell.badge", Color(red: 244 / 255, green: 215 / 255, blue: 215 / 255), Color(red: 255 / 255, green: 239 / 255, blue: 239 / 255), AppColors.danger)
        }
        return ("megaphone", Color(red: 217 / 255, green: 237 / 255, blue: 217 / 255), Color(red: 236 / 255, green: 248 / 255, blue: 236 / 255), AppColors.success)
    }

    private var dateText: String {
        guard let date = comunicado.data else { return "--/--/----" }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(from: date)
    }

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(style.background)
                .frame(width: 34, height: 34)
                .overlay(
                    Image(systemName: style.icon)
                        .foregroundStyle(style.accent)
                )

            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .top) {
                    Text(comunicado.titulo)
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(AppColors.textPrimary)
                    Spacer()
                    Text(dateText)
                        .font(.caption)
                        .foregroundStyle(AppColors.textSecondary)
                }

                Text(comunicado.mensagem)
                    .font(.caption)
                    .foregroundStyle(AppColors.textSecondary)

                Text(comunicado.tipo)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(style.accent)
                    .padding(.top, 2)
            }
        }
        .padding(12)
        .background(Color.white.opacity(0.85), in: RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(style.border, lineWidth: 1)
        )
    }
}
