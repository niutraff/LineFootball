import SwiftUI
import Combine

@MainActor
final class Feature2DetailVM: ObservableObject {

    struct Output {
        let onBack: () -> Void
    }

    @Published
    var playerInfo: PlayerInfo = .initialInfo

    @Published
    var selectedImage: UIImage?

    private let service: Feature2Service
    private var cancellables = Set<AnyCancellable>()

    var output: Output?

    init(service: Feature2Service) {
        self.service = service
    }

    func setSelectedImage(_ image: UIImage?) {
        selectedImage = image
    }

    func incrementAge() {
        playerInfo.age = min(playerInfo.age + 1, 99)
    }

    func decrementAge() {
        playerInfo.age = max(playerInfo.age - 1, 1)
    }

    func savePlayer() {
        var info = playerInfo
        if let image = selectedImage {
            let filename = PlayerPhotoStorage.filename(forPlayerId: info.id)
            if PlayerPhotoStorage.saveImage(image, filename: filename) {
                info.imagePlayer = filename
            }
        }
        Task {
            await service.saveRecord(info)
            await MainActor.run { onBackTapped() }
        }
    }

    func onBackTapped() {
        output?.onBack()
    }
}
