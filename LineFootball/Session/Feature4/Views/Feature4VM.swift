import SwiftUI
import Combine

@MainActor
final class Feature4VM: ObservableObject {
    struct Output {
        let onRateUs: () -> Void
        let onPrivacyPolicy: () -> Void
        let onTermsOfUse: () -> Void
    }

    var output: Output?

    init() {}

    func onRateUsTapped() {
        output?.onRateUs()
    }

    func onPrivacyPolicyTapped() {
        output?.onPrivacyPolicy()
    }

    func onTermsOfUseTapped() {
        output?.onTermsOfUse()
    }
}



