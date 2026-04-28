import SwiftUI

struct ChildSelectionView: View {
    @EnvironmentObject private var session: SessionViewModel

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [AppColors.canvasTop, AppColors.canvasBottom],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 14) {
                GlassCard {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Selecione o filho")
                            .font(.title2.bold())
                            .foregroundStyle(.white)
                        Text("Voce pode trocar de filho depois, a qualquer momento, no topo do app.")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.95))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .background(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(AppColors.primaryBlue)
                )

                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(Array(session.filhos.enumerated()), id: \.element.id) { index, filho in
                            let selected = session.selectedChildIndex == index
                            Button {
                                session.selectChild(index)
                            } label: {
                                HStack(spacing: 12) {
                                    ChildAvatar(name: filho.nome)

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(filho.nome)
                                            .font(.headline)
                                            .foregroundStyle(AppColors.textPrimary)
                                        Text(filho.turma)
                                            .font(.subheadline)
                                            .foregroundStyle(AppColors.textSecondary)
                                    }

                                    Spacer()

                                    Image(systemName: selected ? "checkmark.circle.fill" : "circle")
                                        .foregroundStyle(selected ? AppColors.primaryBlue : AppColors.textSecondary)
                                        .font(.title3)
                                }
                                .padding(14)
                                .frame(maxWidth: .infinity)
                                .background(Color.white.opacity(0.88), in: RoundedRectangle(cornerRadius: 16))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(selected ? AppColors.primaryBlue : Color.white.opacity(0.6), lineWidth: selected ? 1.5 : 1)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.vertical, 4)
                }

                Button {
                    session.confirmChildSelection()
                } label: {
                    Text("Continuar")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(AppColors.success, in: RoundedRectangle(cornerRadius: 12))
                        .foregroundStyle(.white)
                }
                .buttonStyle(.plain)
                .disabled(session.filhos.isEmpty)
            }
            .padding(18)
        }
    }
}
