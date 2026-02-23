import SwiftUI
import Combine

@MainActor
protocol Feature1CoordinatorElementsFactory {
    func feature1VM() -> Feature1VM
    func feature1DetailVM() -> Feature1DetailVM
}

@MainActor
final class Feature1Coordinator: ObservableObject {

    let navigation: Feature1CoordinatorNavigation
    private let elementsFactory: Feature1CoordinatorElementsFactory
    private var _viewModel: Feature1VM?

    private var viewModel: Feature1VM {
        if let vm = _viewModel { return vm }
        let vm = elementsFactory.feature1VM()
        vm.output = .init(
            onDetail: { [weak self] in self?.showDetail() }
        )
        _viewModel = vm
        return vm
    }

    init(
        navigation: Feature1CoordinatorNavigation,
        elementsFactory: Feature1CoordinatorElementsFactory
    ) {
        self.navigation = navigation
        self.elementsFactory = elementsFactory
    }

    func showMain() -> some View {
        navigation.view(for: .main(viewModel))
    }

    private func showDetail() {
        let detailVM = elementsFactory.feature1DetailVM()
        detailVM.output = .init(
            onBack: { [weak self] in self?.navigation.navigateBack() }
        )
        navigation.navigateTo(.detail(detailVM))
    }
}
