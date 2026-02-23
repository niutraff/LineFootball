import Foundation

struct PlayerInfo: Identifiable, Codable {
    var id = UUID().uuidString
    var imagePlayer: String
    var fisrtName: String
    var secondName: String
    var position: String
    var age: Int
}

extension PlayerInfo {
    static let initialInfo: PlayerInfo = .init(imagePlayer: "", fisrtName: "", secondName: "", position: "", age: 18)
    
    var isValid: Bool {
        fisrtName.isEmpty || secondName.isEmpty
    }
}
