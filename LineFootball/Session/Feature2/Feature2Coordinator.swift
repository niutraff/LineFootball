import SwiftUI
import Combine

@MainActor
protocol Feature2CoordinatorElementsFactory {
    func feature2VM() -> Feature2VM
    func feature2DetailVM() -> Feature2DetailVM
}

@MainActor
final class Feature2Coordinator: ObservableObject {

    let navigation: Feature2CoordinatorNavigation
    private let elementsFactory: Feature2CoordinatorElementsFactory
    private var _viewModel: Feature2VM?

    private var viewModel: Feature2VM {
        if let vm = _viewModel { return vm }
        let vm = elementsFactory.feature2VM()
        vm.output = .init(
            onDetail: { [weak self] in self?.showDetail() }
        )
        _viewModel = vm
        return vm
    }

    init(
        navigation: Feature2CoordinatorNavigation,
        elementsFactory: Feature2CoordinatorElementsFactory
    ) {
        self.navigation = navigation
        self.elementsFactory = elementsFactory
    }

    func showMain() -> some View {
        navigation.view(for: .main(viewModel))
    }

    private func showDetail() {
        let detailVM = elementsFactory.feature2DetailVM()
        detailVM.output = .init(
            onBack: { [weak self] in self?.navigation.navigateBack() }
        )
        navigation.navigateTo(.detail(detailVM))
    }
}
