import SwiftUI

struct FrequenciaView: View {
    let filho: Filho

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("Frequencia")
                    .font(.title3.bold())
                    .foregroundStyle(AppColors.textPrimary)

                GlassCard {
                    HStack {
                        SummaryNumberView(title: "Frequencia geral", value: "\(filho.frequenciaGeral)%", color: AppColors.success)
                        Spacer()
                        SummaryNumberView(
                            title: "Faltas",
                            value: "\(filho.faltas)",
                            color: filho.faltas >= 10 ? AppColors.danger : AppColors.warning
                        )
                        Spacer()
                        SummaryNumberView(
                            title: "Chamadas",
                            value: "\(filho.chamadasRespondidas)/\(filho.totalChamadas)",
                            color: AppColors.accentBlue
                        )
                    }
                }

                let total = max(filho.totalChamadas, 1)
                let progress = Double(filho.chamadasRespondidas) / Double(total)
                GlassCard {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Chamadas respondidas")
                            .font(.headline)
                        ProgressView(value: progress)
                            .tint(AppColors.primaryBlue)
                            .progressViewStyle(.linear)
                            .frame(height: 10)
                        Text("\(String(format: "%.1f", progress * 100).replacingOccurrences(of: ".", with: ","))% de retorno das chamadas")
                            .font(.caption)
                            .foregroundStyle(AppColors.textSecondary)
                    }
                }

                GlassCard {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Frequencia por disciplina")
                            .font(.headline)
                        ForEach(Array(filho.disciplinas.enumerated()), id: \.element.id) { index, disciplina in
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(disciplina.nome)
                                        .font(.subheadline.weight(.semibold))
                                    Spacer()
                                    Text("\(disciplina.frequencia)%")
                                        .font(.subheadline.weight(.bold))
                                        .foregroundStyle(disciplina.frequencia >= 90 ? AppColors.success : AppColors.warning)
                                    Text("Faltas: \(disciplina.faltas)")
                                        .font(.caption)
                                        .foregroundStyle(AppColors.textSecondary)
                                }
                                ProgressView(value: Double(disciplina.frequencia) / 100)
                                    .tint(disciplina.frequencia >= 90 ? AppColors.success : AppColors.warning)
                            }
                            if index < filho.disciplinas.count - 1 {
                                Divider().overlay(Color.white.opacity(0.7))
                            }
                        }
                    }
                }
            }
            .padding(16)
            .padding(.bottom, 24)
        }
        .scrollIndicators(.hidden)
    }
}

private struct SummaryNumberView: View {
    let title: String
    let value: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundStyle(AppColors.textSecondary)
            Text(value)
                .font(.title3.weight(.black))
                .foregroundStyle(color)
                .minimumScaleFactor(0.7)
        }
    }
}
