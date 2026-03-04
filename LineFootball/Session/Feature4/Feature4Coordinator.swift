import SwiftUI
import Combine

@MainActor
protocol Feature4CoordinatorElementsFactory {
    func feature4VM() -> Feature4VM
}

@MainActor
final class Feature4Coordinator: ObservableObject {

    let navigation: Feature4CoordinatorNavigation
    private let elementsFactory: Feature4CoordinatorElementsFactory
    private var _viewModel: Feature4VM?

    private var viewModel: Feature4VM {
        if let vm = _viewModel { return vm }
        let vm = elementsFactory.feature4VM()
        vm.output = .init(
            onRateUs: { [weak self] in self?.handleRateUs() },
            onPrivacyPolicy: { [weak self] in self?.handlePrivacyPolicy() },
            onTermsOfUse: { [weak self] in self?.handleTermsOfUse() }
        )
        _viewModel = vm
        return vm
    }

    init(
        navigation: Feature4CoordinatorNavigation,
        elementsFactory: Feature4CoordinatorElementsFactory
    ) {
        self.navigation = navigation
        self.elementsFactory = elementsFactory
    }

    func showMain() -> some View {
        navigation.view(for: .main(viewModel))
    }
    
    private func handleRateUs() {
        openGoogle()
    }
    
    private func handlePrivacyPolicy() {
        guard let url = URL(string: "https://www.freeprivacypolicy.com/live/3b70cb69-e115-4f7a-ade7-dd70317583a0") else { return }
        showDetail(url: url, title: "settings.privacyPolicy".localized())
    }

    private func handleTermsOfUse() {
        guard let url = URL(string: "https://www.freeprivacypolicy.com/live/01c50a28-f97f-42cf-81e8-b348310e7575") else { return }
        showDetail(url: url, title: "settings.termsOfUse".localized())
    }

    private func showDetail(url: URL, title: String) {
        let vm = Feature4DetailVM(url: url, title: title)
        vm.output = .init(
            onBack: { [weak self] in self?.navigation.navigateBack() }
        )
        navigation.navigateTo(.detail(vm))
    }

    private func openGoogle() {
        guard let url = URL(string: "https://landing.line-football-stats.info/") else { return }
        UIApplication.shared.open(url)
    }
}
