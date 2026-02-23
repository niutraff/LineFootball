import SwiftUI
import Combine

final class Feature3CoordinatorNavigation: NavigationStorable {

    enum Screen: ScreenIdentifiable {
        case main(Feature3VM)
        case detail(Feature3DetailVM)

        var screenID: ObjectIdentifier {
            switch self {
            case .main(let vm):
                return ObjectIdentifier(vm)
            case .detail(let vm):
                return ObjectIdentifier(vm)
            }
        }
    }

    @Published var path: NavigationPath = NavigationPath()

    @ViewBuilder
    func view(for screen: Screen) -> some View {
        switch screen {
        case .main(let vm):
            Feature3View(viewModel: vm)
        case .detail(let vm):
            Feature3DetailView(viewModel: vm)
        }
    }
}
