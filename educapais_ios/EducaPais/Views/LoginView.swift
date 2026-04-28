import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var session: SessionViewModel
    @State private var email = SessionViewModel.validEmail
    @State private var password = SessionViewModel.validPassword
    @State private var isSecure = true
    @State private var showErrorAlert = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [AppColors.primaryBlue, AppColors.accentBlue],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 16) {
                Spacer()
                logoBlock

                GlassCard {
                    VStack(spacing: 12) {
                        TextField("E-mail ou CPF", text: $email)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)
                            .padding(12)
                            .background(Color.white.opacity(0.9), in: RoundedRectangle(cornerRadius: 12))

                        HStack {
                            Group {
                                if isSecure {
                                    SecureField("Senha", text: $password)
                                } else {
                                    TextField("Senha", text: $password)
                                }
                            }
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)
                            .padding(.leading, 12)

                            Button {
                                isSecure.toggle()
                            } label: {
                                Image(systemName: isSecure ? "eye.slash" : "eye")
                                    .foregroundStyle(AppColors.textSecondary)
                            }
                            .padding(.horizontal, 12)
                        }
                        .padding(.vertical, 10)
                        .background(Color.white.opacity(0.9), in: RoundedRectangle(cornerRadius: 12))

                        Button(action: signIn) {
                            HStack {
                                if session.isBusy {
                                    ProgressView()
                                        .tint(.white)
                                } else {
                                    Text("Entrar")
                                        .font(.headline)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(AppColors.success, in: RoundedRectangle(cornerRadius: 12))
                            .foregroundStyle(.white)
                        }
                        .disabled(session.isBusy)
                    }
                }
                .padding(.horizontal, 22)

                Text("Esqueci minha senha")
                    .font(.subheadline)
                    .foregroundStyle(Color.white.opacity(0.95))

                Spacer()

                Text("Nao tem conta? Fale com a escola.")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(Color.white.opacity(0.95))
                    .padding(.bottom, 20)
            }
        }
        .alert("Falha no login", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(session.errorMessage ?? "Nao foi possivel entrar.")
        }
    }

    private var logoBlock: some View {
        VStack(spacing: 10) {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.white.opacity(0.12))
                .frame(width: 102, height: 102)
                .overlay(
                    Image(systemName: "building.columns.fill")
                        .font(.system(size: 44))
                        .foregroundStyle(.white)
                )

            Text("EducaPais")
                .font(.system(size: 46, weight: .heavy, design: .rounded))
                .foregroundStyle(.white)

            Text("Acompanhe. Participe. Inspire.")
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.white.opacity(0.95))

            Text("Bem-vindo(a)!")
                .font(.title2.weight(.bold))
                .foregroundStyle(.white)
                .padding(.top, 6)

            Text("Faca login para acessar a vida escolar dos seus filhos.")
                .font(.callout)
                .foregroundStyle(.white.opacity(0.95))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 18)
        }
    }

    private func signIn() {
        Task {
            let ok = await session.login(email: email, password: password)
            if !ok {
                showErrorAlert = true
            }
        }
    }
}
