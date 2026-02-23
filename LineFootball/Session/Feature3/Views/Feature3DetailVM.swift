import SwiftUI
import Combine

@MainActor
final class Feature3DetailVM: ObservableObject {

    struct Output {
        let onBack: () -> Void
    }
    
    @Published
    var matchInfo: MatchInfo = .initialData
    
    private let service: Feature3Service
    private var cancellables = Set<AnyCancellable>()

    var output: Output?

    init(service: Feature3Service) {
        self.service = service
    }
    
    func saveMatch() {
        Task {
            await service.saveRecord(matchInfo)
            await MainActor.run { onBackTapped() }
        }
    }

    func onBackTapped() {
        output?.onBack()
    }
}
