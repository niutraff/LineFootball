import SwiftUI
import Combine

@MainActor
final class Feature1DetailVM: ObservableObject {

    struct Output {
        let onBack: () -> Void
    }

    var output: Output?

    @Published var comandInfo: ComandInfo = .initialInfo

    private let service: Feature1Service
    private var cancellables = Set<AnyCancellable>()

    init(service: Feature1Service) {
        self.service = service
    }

    func saveComandInfo() {
        Task { await service.saveRecord(comandInfo) }
        onBackTapped()
    }

    func onBackTapped() {
        output?.onBack()
    }

    // MARK: - Score
    func setWeWereHomeTeam(_ value: Bool) {
        comandInfo.weWereHomeTeam = value
    }

    func incrementGoalUs() { comandInfo.goalUs = min(comandInfo.goalUs + 1, 999) }
    func decrementGoalUs() { comandInfo.goalUs = max(comandInfo.goalUs - 1, 0) }
    func incrementGoalThem() { comandInfo.goalThem = min(comandInfo.goalThem + 1, 999) }
    func decrementGoalThem() { comandInfo.goalThem = max(comandInfo.goalThem - 1, 0) }
    func incrementSaves() { comandInfo.saves = min(comandInfo.saves + 1, 999) }
    func decrementSaves() { comandInfo.saves = max(comandInfo.saves - 1, 0) }
    func incrementAssits() { comandInfo.assits = min(comandInfo.assits + 1, 999) }
    func decrementAssits() { comandInfo.assits = max(comandInfo.assits - 1, 0) }

    // MARK: - Cards
    func incrementYellowCard() { comandInfo.yellowCard = min(comandInfo.yellowCard + 1, 99) }
    func decrementYellowCard() { comandInfo.yellowCard = max(comandInfo.yellowCard - 1, 0) }
    func incrementRedCard() { comandInfo.redCard = min(comandInfo.redCard + 1, 99) }
    func decrementRedCard() { comandInfo.redCard = max(comandInfo.redCard - 1, 0) }

    /// Текст счёта: "Home X - Y Away" (или наоборот если мы гости)
    var scorelineText: String {
        let home = comandInfo.weWereHomeTeam ? comandInfo.homeTeam : comandInfo.awayTeam
        let away = comandInfo.weWereHomeTeam ? comandInfo.awayTeam : comandInfo.homeTeam
        let homeGoals = comandInfo.weWereHomeTeam ? comandInfo.goalUs : comandInfo.goalThem
        let awayGoals = comandInfo.weWereHomeTeam ? comandInfo.goalThem : comandInfo.goalUs
        let homeName = home.isEmpty ? "Home" : home
        let awayName = away.isEmpty ? "Away" : away
        return "\(homeName) \(homeGoals) - \(awayGoals) \(awayName)"
    }
}
