import SwiftUI

struct BoletimView: View {
    let filho: Filho

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("Resumo")
                    .font(.title3.bold())
                    .foregroundStyle(AppColors.textPrimary)

                GlassCard {
                    HStack(spacing: 10) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Media geral")
                                .font(.subheadline)
                                .foregroundStyle(AppColors.textSecondary)
                            Text(decimal(filho.mediaGeral))
                                .font(.system(size: 44, weight: .heavy, design: .rounded))
                                .foregroundStyle(AppColors.success)
                                .minimumScaleFactor(0.7)
                            Text(filho.mediaGeral >= 7 ? "Otimo desempenho" : "Atencao ao rendimento")
                                .font(.footnote)
                                .foregroundStyle(AppColors.textSecondary)
                        }
                        Spacer()
                        CircularProgressView(value: Double(filho.frequenciaGeral) / 100, label: "\(filho.frequenciaGeral)%")
                    }
                }

                GlassCard {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Disciplinas")
                            .font(.headline)
                        ForEach(Array(filho.disciplinas.enumerated()), id: \.element.id) { index, disciplina in
                            HStack(spacing: 10) {
                                Image(systemName: "book.closed")
                                    .foregroundStyle(AppColors.accentBlue)
                                Text(disciplina.nome)
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(AppColors.textPrimary)
                                Spacer()
                                Text(decimal(disciplina.media))
                                    .font(.system(size: 28, weight: .heavy, design: .rounded))
                                    .foregroundStyle(scoreColor(disciplina.media))
                            }
                            if index < filho.disciplinas.count - 1 {
                                Divider().overlay(Color.white.opacity(0.7))
                            }
                        }
                    }
                }

                HStack {
                    Text("Media do periodo")
                        .font(.headline)
                        .foregroundStyle(AppColors.success)
                    Spacer()
                    Text(decimal(filho.mediaGeral))
                        .font(.system(size: 34, weight: .black, design: .rounded))
                        .foregroundStyle(AppColors.success)
                }
                .padding(14)
                .background(Color(red: 234 / 255, green: 248 / 255, blue: 237 / 255), in: RoundedRectangle(cornerRadius: 14))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color(red: 212 / 255, green: 239 / 255, blue: 217 / 255), lineWidth: 1)
                )
            }
            .padding(16)
            .padding(.bottom, 24)
        }
        .scrollIndicators(.hidden)
    }

    private func scoreColor(_ value: Double) -> Color {
        if value >= 8 {
            return AppColors.success
        }
        if value >= 7 {
            return AppColors.warning
        }
        return AppColors.danger
    }

    private func decimal(_ value: Double) -> String {
        String(format: "%.1f", value).replacingOccurrences(of: ".", with: ",")
    }
}

private struct CircularProgressView: View {
    let value: Double
    let label: String

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.white.opacity(0.6), style: StrokeStyle(lineWidth: 8, lineCap: .round))
            Circle()
                .trim(from: 0, to: min(max(value, 0), 1))
                .stroke(AppColors.success, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .rotationEffect(.degrees(-90))
            VStack(spacing: 0) {
                Text(label)
                    .font(.headline.bold())
                    .foregroundStyle(AppColors.textPrimary)
                Text("Presenca")
                    .font(.caption2)
                    .foregroundStyle(AppColors.textSecondary)
            }
        }
        .frame(width: 96, height: 96)
    }
}
