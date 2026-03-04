import Foundation
import Combine

@MainActor
final class Feature4DetailVM: ObservableObject {
    struct Output {
        let onBack: () -> Void
    }

    var output: Output?

    let url: URL
    let title: String

    init(url: URL, title: String) {
        self.url = url
        self.title = title
    }

    func onBackTapped() {
        output?.onBack()
    }
}
