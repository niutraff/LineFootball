import Foundation
import Combine

@MainActor
final class Feature3VM: ObservableObject {

    struct Output {
        let onDetail: () -> Void
    }
    
    @Published
    var records: [MatchInfo] = []

    var output: Output?

    private let service: Feature3Service
    private var cancellables = Set<AnyCancellable>()

    init(service: Feature3Service) {
        self.service = service
        subscribeToRecords()
    }
    
    private func subscribeToRecords() {
        service.recordsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success(let info):
                    self?.records = info
                case .failure(let error):
                    print(error.errorDescription ?? "Unknown error")
                }
            }
            .store(in: &cancellables)
    }

    /// Обновить список при появлении экрана (после возврата с добавления/редактирования).
    func refreshRecords() {
        Task {
            let list = await service.getRecords()
            await MainActor.run { [weak self] in
                self?.records = list
            }
        }
    }

    func onDetailTapped() {
        output?.onDetail()
    }
}
