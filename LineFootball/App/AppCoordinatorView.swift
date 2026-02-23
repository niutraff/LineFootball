import SwiftUI

struct AppCoordinatorView: View {

    @ObservedObject var coordinator: AppCoordinator

    var body: some View {
        VStack {
            if let viewState = coordinator.viewState {
                content(for: viewState)
            }
        }
        .task {
            await coordinator.onAppear()
        }
    }

    @ViewBuilder
    private func content(for viewState: AppCoordinator.ViewState) -> some View {
        switch viewState {
        case .session(let coordinator):
            SessionCoordinatorView(coordinator: coordinator)
            
        case .mediaView(let url):
            MediaViewContainer(url: url)
        }
    }
}

#Preview {
    AppCoordinatorView(coordinator: AppCoordinator())
}
