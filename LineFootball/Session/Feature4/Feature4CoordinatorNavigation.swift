import SwiftUI
import Combine

@MainActor
final class Feature4CoordinatorNavigation: NavigationStorable {

    enum Screen: ScreenIdentifiable {
        case main(Feature4VM)
        case detail(Feature4DetailVM)

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
            Feature4View(viewModel: vm)
        case .detail(let vm):
            Feature4DetailView(viewModel: vm)
        }
    }
}
