import Foundation

struct ComandInfo: Identifiable , Codable {
    var id = UUID().uuidString
    var homeTeam: String
    var awayTeam: String
    var date: Date
    var time: Date
    var weWereHomeTeam: Bool
    var goalUs: Int
    var goalThem: Int
    var saves: Int
    var assits: Int
    var yellowCard: Int
    var redCard: Int

    init(id: String = UUID().uuidString, homeTeam: String, awayTeam: String, date: Date, time: Date, weWereHomeTeam: Bool = true, goalUs: Int, goalThem: Int, saves: Int, assits: Int, yellowCard: Int, redCard: Int) {
        self.id = id
        self.homeTeam = homeTeam
        self.awayTeam = awayTeam
        self.date = date
        self.time = time
        self.weWereHomeTeam = weWereHomeTeam
        self.goalUs = goalUs
        self.goalThem = goalThem
        self.saves = saves
        self.assits = assits
        self.yellowCard = yellowCard
        self.redCard = redCard
    }

    enum CodingKeys: String, CodingKey {
        case id, homeTeam, awayTeam, date, time, weWereHomeTeam
        case goalUs, goalThem, saves, assits, yellowCard, redCard
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decodeIfPresent(String.self, forKey: .id) ?? UUID().uuidString
        homeTeam = try c.decode(String.self, forKey: .homeTeam)
        awayTeam = try c.decode(String.self, forKey: .awayTeam)
        date = try c.decode(Date.self, forKey: .date)
        time = try c.decode(Date.self, forKey: .time)
        weWereHomeTeam = try c.decodeIfPresent(Bool.self, forKey: .weWereHomeTeam) ?? true
        goalUs = try c.decode(Int.self, forKey: .goalUs)
        goalThem = try c.decode(Int.self, forKey: .goalThem)
        saves = try c.decode(Int.self, forKey: .saves)
        assits = try c.decode(Int.self, forKey: .assits)
        yellowCard = try c.decode(Int.self, forKey: .yellowCard)
        redCard = try c.decode(Int.self, forKey: .redCard)
    }
}

extension ComandInfo {
    static let initialInfo: ComandInfo = .init(homeTeam: "", awayTeam: "", date: .now, time: .now, weWereHomeTeam: true, goalUs: 0, goalThem: 0, saves: 0, assits: 0, yellowCard: 0, redCard: 0)

    /// Общее количество карточек (показывать только если > 0)
    var totalCards: Int { yellowCard + redCard }
    
    var isValid: Bool {
        homeTeam.isEmpty || awayTeam.isEmpty
    }
}
