import Foundation

@MainActor
final class SessionViewModel: ObservableObject {
    private let apiService: APIService
    private let cacheService: CacheService

    static let validEmail = "pai@email.com"
    static let validPassword = "123456"

    @Published var isBusy = false
    @Published var isLoggedIn = false
    @Published var requiresChildSelection = false
    @Published var selectedTab = 0
    @Published var selectedChildIndex = 0
    @Published var data: EducaPaisData?
    @Published var errorMessage: String?
    @Published var source: DataSourceType?
    @Published var lastUpdatedAt: Date?

    enum DataSourceType {
        case network
        case cache
    }

    init(apiService: APIService = APIService(), cacheService: CacheService = CacheService()) {
        self.apiService = apiService
        self.cacheService = cacheService
    }

    var filhos: [Filho] {
        data?.filhos ?? []
    }

    var responsavel: Responsavel? {
        data?.responsavel
    }

    var selectedFilho: Filho? {
        guard let data, !data.filhos.isEmpty else {
            return nil
        }
        if selectedChildIndex < 0 || selectedChildIndex >= data.filhos.count {
            return data.filhos.first
        }
        return data.filhos[selectedChildIndex]
    }

    var isOfflineData: Bool {
        source == .cache
    }

    func login(email: String, password: String) async -> Bool {
        guard !isBusy else {
            return false
        }

        guard email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == Self.validEmail,
              password.trimmingCharacters(in: .whitespacesAndNewlines) == Self.validPassword else {
            errorMessage = "Credenciais invalidas. Use pai@email.com e 123456."
            return false
        }

        isBusy = true
        defer { isBusy = false }

        do {
            let result = try await loadData()
            data = result.data
            source = result.source
            lastUpdatedAt = result.date
            selectedChildIndex = 0
            selectedTab = 0
            isLoggedIn = true
            requiresChildSelection = true
            errorMessage = nil
            return true
        } catch {
            errorMessage = "Nao foi possivel carregar dados. Conecte-se para carregar ao menos uma vez."
            return false
        }
    }

    func refresh() async {
        guard !isBusy, isLoggedIn else {
            return
        }

        isBusy = true
        defer { isBusy = false }

        do {
            let result = try await loadData()
            data = result.data
            source = result.source
            lastUpdatedAt = result.date
            errorMessage = nil
        } catch {
            errorMessage = "Falha ao atualizar. Exibindo cache local."
        }
    }

    func selectChild(_ index: Int) {
        guard index >= 0, index < filhos.count else {
            return
        }
        selectedChildIndex = index
    }

    func confirmChildSelection() {
        requiresChildSelection = false
    }

    func logout() {
        isLoggedIn = false
        requiresChildSelection = false
        selectedTab = 0
        errorMessage = nil
    }

    private func loadData() async throws -> (data: EducaPaisData, source: DataSourceType, date: Date?) {
        do {
            let payload = try await apiService.fetchPayload()
            let parsed = try EducaPaisData.decode(from: payload)
            cacheService.savePayload(payload)
            return (parsed, .network, Date())
        } catch {
            guard let payload = cacheService.readPayload() else {
                throw error
            }
            let parsed = try EducaPaisData.decode(from: payload)
            return (parsed, .cache, cacheService.readDate())
        }
    }
}
