import Foundation

struct EducaPaisData {
    let responsavel: Responsavel
    let filhos: [Filho]

    static func decode(from payload: String) throws -> EducaPaisData {
        guard let data = payload.data(using: .utf8) else {
            throw ParseError.invalidPayload
        }

        let object = try JSONSerialization.jsonObject(with: data)
        let root = try extractRoot(from: object)

        let responsavelDict = root["responsavel"] as? [String: Any] ?? [:]
        let filhosArray = root["filhos"] as? [[String: Any]] ?? []

        let responsavel = Responsavel(from: responsavelDict)
        let filhos = filhosArray.map(Filho.init(from:))

        if filhos.isEmpty {
            throw ParseError.noChildrenFound
        }

        return EducaPaisData(responsavel: responsavel, filhos: filhos)
    }

    private static func extractRoot(from any: Any) throws -> [String: Any] {
        if let list = any as? [[String: Any]] {
            if let valid = list.first(where: { $0["responsavel"] != nil && $0["filhos"] is [[String: Any]] }) {
                return valid
            }
        }

        if let dict = any as? [String: Any] {
            if dict["responsavel"] != nil, dict["filhos"] is [[String: Any]] {
                return dict
            }
            if let value = dict["value"] {
                return try extractRoot(from: value)
            }
            if let value = dict["data"] {
                return try extractRoot(from: value)
            }
        }

        throw ParseError.noValidRoot
    }

    enum ParseError: Error {
        case invalidPayload
        case noValidRoot
        case noChildrenFound
    }
}

struct Responsavel {
    let id: String
    let nome: String
    let email: String
    let senha: String

    var primeiroNome: String {
        nome.split(separator: " ").first.map(String.init) ?? nome
    }

    init(from json: [String: Any]) {
        id = parseString(json["id"])
        nome = parseString(json["nome"])
        email = parseString(json["email"])
        senha = parseString(json["senha"])
    }
}

struct Filho: Identifiable {
    let id: String
    let nome: String
    let turma: String
    let mediaGeral: Double
    let frequenciaGeral: Int
    let faltas: Int
    let chamadasRespondidas: Int
    let totalChamadas: Int
    let disciplinas: [Disciplina]
    let comunicados: [Comunicado]

    init(from json: [String: Any]) {
        id = parseString(json["id"])
        nome = parseString(json["nome"])
        turma = parseString(json["turma"])
        mediaGeral = parseDouble(json["mediaGeral"])
        frequenciaGeral = parseInt(json["frequenciaGeral"])
        faltas = parseInt(json["faltas"])
        chamadasRespondidas = parseInt(json["chamadasRespondidas"])
        totalChamadas = parseInt(json["totalChamadas"])
        let disciplinasArray = json["disciplinas"] as? [[String: Any]] ?? []
        let comunicadosArray = json["comunicados"] as? [[String: Any]] ?? []
        disciplinas = disciplinasArray.map(Disciplina.init(from:))
        comunicados = comunicadosArray.map(Comunicado.init(from:))
    }
}

struct Disciplina: Identifiable {
    let id = UUID()
    let nome: String
    let nota1: Double
    let nota2: Double
    let media: Double
    let frequencia: Int
    let faltas: Int

    init(from json: [String: Any]) {
        nome = parseString(json["nome"])
        nota1 = parseDouble(json["nota1"])
        nota2 = parseDouble(json["nota2"])
        media = parseDouble(json["media"])
        frequencia = parseInt(json["frequencia"])
        faltas = parseInt(json["faltas"])
    }
}

struct Comunicado: Identifiable {
    let id = UUID()
    let tipo: String
    let titulo: String
    let mensagem: String
    let data: Date?

    init(from json: [String: Any]) {
        tipo = parseString(json["tipo"])
        titulo = parseString(json["titulo"])
        mensagem = parseString(json["mensagem"])
        data = parseDate(json["data"])
    }
}

private func parseString(_ value: Any?) -> String {
    if let str = value as? String {
        return str
    }
    if let number = value as? NSNumber {
        return number.stringValue
    }
    return ""
}

private func parseInt(_ value: Any?) -> Int {
    if let intValue = value as? Int {
        return intValue
    }
    if let number = value as? NSNumber {
        return number.intValue
    }
    if let stringValue = value as? String, let parsed = Int(stringValue) {
        return parsed
    }
    return 0
}

private func parseDouble(_ value: Any?) -> Double {
    if let doubleValue = value as? Double {
        return doubleValue
    }
    if let number = value as? NSNumber {
        return number.doubleValue
    }
    if let stringValue = value as? String {
        let normalized = stringValue.replacingOccurrences(of: ",", with: ".")
        return Double(normalized) ?? 0
    }
    return 0
}

private func parseDate(_ value: Any?) -> Date? {
    guard let raw = value as? String, !raw.isEmpty else {
        return nil
    }

    let isoFormatter = ISO8601DateFormatter()
    if let date = isoFormatter.date(from: raw) {
        return date
    }

    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.locale = Locale(identifier: "pt_BR")
    return formatter.date(from: raw)
}
