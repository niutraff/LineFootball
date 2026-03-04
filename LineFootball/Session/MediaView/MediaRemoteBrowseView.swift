import SwiftUI
import Browse

struct MediaRemoteBrowseView: View {

    @ObservedObject var presentation: BrowsePresentationController

    var body: some View {
        ZStack {
            if let url = presentation.url {
                BrowseView(
                    url: url,
                    store: presentation.store,
                    configuration: presentation.configuration
                )
            } else {
                Color.clear
            }

            if presentation.shouldCoverContent {
                SplashView()
                    .transition(.opacity)
            }
        }
        .onAppear {
            presentation.beginPresentation()
        }
        .animation(.easeOut(duration: 0.3), value: presentation.shouldCoverContent)
    }
}

struct SplashView: View {
    @State private var isAnimating = false

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Color(.palette(.backColor))
                    .ignoresSafeArea()

                Image(.logo)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
            }
            .onAppear {
                isAnimating = true
            }
        }
    }
}
