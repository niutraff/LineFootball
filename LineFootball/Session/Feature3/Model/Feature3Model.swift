import Foundation

struct MatchInfo: Identifiable, Codable {
    var id = UUID().uuidString
    var homeTeam: String
    var awayTeam: String
    var date: Date
    var time: Date
    var location: String
}

extension MatchInfo {
    static let initialData: MatchInfo = .init(homeTeam: "", awayTeam: "", date: .now, time: .now, location: "")
    
    var isValid: Bool {
        homeTeam.isEmpty || awayTeam.isEmpty || location.isEmpty
    }
}
