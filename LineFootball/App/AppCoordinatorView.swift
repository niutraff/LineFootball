import SwiftUI

struct AppCoordinatorView: View {

    @ObservedObject var coordinator: AppCoordinator

    var body: some View {
        VStack {
            if let viewState = coordinator.viewState {
                content(for: viewState)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(content: overlayContent)
        .task {
            await coordinator.onAppear()
        }
        .fullScreenCover(item: $coordinator.notificationOnbVM) { vm in
            NotificationOnbView(viewModel: vm)
        }
#if DEBUG
        .fullScreenCover(isPresented: $coordinator.showDevMenu) {
            DevMenuView()
        }
        .onReceive(NotificationCenter.default.publisher(for: .deviceDidShake)) { _ in
            coordinator.showDevMenu = true
        }
#endif
    }

    @ViewBuilder
    private func content(for viewState: AppCoordinator.ViewState) -> some View {
        switch viewState {
        case .session(let coordinator):
            SessionCoordinatorView(coordinator: coordinator)
            
        case .mediaView(let presentation):
            MediaRemoteBrowseView(presentation: presentation)
        }
    }
    
    @ViewBuilder
    private func overlayContent() -> some View {
        if let overlay = coordinator.overlay {
            switch overlay {
            case .splash:
                SplashView()
            }
        }
    }
}

#Preview {
    AppCoordinatorView(coordinator: AppCoordinator())
}
