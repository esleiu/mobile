import SwiftUI
import UIKit

struct DashboardView: View {
    @EnvironmentObject private var session: SessionViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [AppColors.canvasTop, AppColors.canvasBottom],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                if let filho = session.selectedFilho {
                    VStack(spacing: 0) {
                        DashboardHeaderView(filho: filho)
                            .environmentObject(session)
                        if session.isOfflineData {
                            OfflineBannerView()
                        }
                        TabView(selection: $session.selectedTab) {
                            BoletimView(filho: filho)
                                .tag(0)
                                .tabItem {
                                    Label("Boletim", systemImage: "book.closed")
                                }
                            FrequenciaView(filho: filho)
                                .tag(1)
                                .tabItem {
                                    Label("Frequencia", systemImage: "clock")
                                }
                            ComunicadosView(filho: filho)
                                .tag(2)
                                .tabItem {
                                    Label("Comunicados", systemImage: "bell")
                                }
                        }
                        .tint(AppColors.primaryBlue)
                    }
                } else {
                    ProgressView("Carregando dados...")
                        .foregroundStyle(AppColors.textSecondary)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

private struct DashboardHeaderView: View {
    @EnvironmentObject private var session: SessionViewModel
    let filho: Filho

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM HH:mm"
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter
    }

    var body: some View {
        VStack(spacing: 10) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Ola, \(session.responsavel?.primeiroNome ?? "")!")
                        .font(.title2.bold())
                        .foregroundStyle(.white)
                    Text("Bem-vindo de volta")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.9))
                }
                Spacer()
                Button {
                    Task { await session.refresh() }
                } label: {
                    if session.isBusy {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Image(systemName: "arrow.clockwise")
                            .foregroundStyle(.white)
                    }
                }
                .padding(.horizontal, 4)
                Button {
                    session.logout()
                } label: {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .foregroundStyle(.white)
                }
            }

            GlassCard {
                HStack(spacing: 12) {
                    ChildAvatar(name: filho.nome, size: 54)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(filho.nome)
                            .font(.headline)
                            .foregroundStyle(AppColors.textPrimary)
                        Text(filho.turma)
                            .font(.subheadline)
                            .foregroundStyle(AppColors.textSecondary)
                        if let date = session.lastUpdatedAt {
                            Text("Atualizado em \(dateFormatter.string(from: date))")
                                .font(.caption)
                                .foregroundStyle(AppColors.textSecondary)
                        }
                    }
                    Spacer()
                }
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(Array(session.filhos.enumerated()), id: \.element.id) { index, child in
                        let selected = index == session.selectedChildIndex
                        Button {
                            session.selectChild(index)
                        } label: {
                            Text(child.nome)
                                .font(.subheadline.weight(.semibold))
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(selected ? Color.white : Color.white.opacity(0.14), in: Capsule())
                                .foregroundStyle(selected ? AppColors.primaryBlue : Color.white)
                                .overlay(
                                    Capsule()
                                        .stroke(Color.white.opacity(selected ? 0 : 0.6), lineWidth: selected ? 0 : 1)
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 10)
        .padding(.bottom, 16)
        .background(AppColors.primaryBlue)
        .clipShape(RoundedCornersShape(radius: 24, corners: [.bottomLeft, .bottomRight]))
    }
}

private struct OfflineBannerView: View {
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "wifi.slash")
                .foregroundStyle(AppColors.warning)
            Text("Modo offline: exibindo dados salvos localmente.")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(Color(red: 109 / 255, green: 85 / 255, blue: 8 / 255))
            Spacer()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(Color(red: 252 / 255, green: 235 / 255, blue: 207 / 255))
    }
}

private struct RoundedCornersShape: Shape {
    var radius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
