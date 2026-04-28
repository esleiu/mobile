import Foundation

struct APIService {
    static let endpoint = URL(string: "https://69effdd0112e1b968e251fe2.mockapi.io/api/educapais")!

    func fetchPayload() async throws -> String {
        let (data, response) = try await URLSession.shared.data(from: Self.endpoint)
        guard let httpResponse = response as? HTTPURLResponse,
              (200 ..< 300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        if let text = String(data: data, encoding: .utf8) {
            return text
        }
        if let text = String(data: data, encoding: .isoLatin1) {
            return text
        }
        throw URLError(.cannotDecodeRawData)
    }
}
