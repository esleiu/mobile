import Foundation

struct CacheService {
    private let payloadKey = "educapais_payload_cache"
    private let dateKey = "educapais_payload_cache_date"

    func savePayload(_ payload: String) {
        UserDefaults.standard.set(payload, forKey: payloadKey)
        UserDefaults.standard.set(Date(), forKey: dateKey)
    }

    func readPayload() -> String? {
        UserDefaults.standard.string(forKey: payloadKey)
    }

    func readDate() -> Date? {
        UserDefaults.standard.object(forKey: dateKey) as? Date
    }
}
