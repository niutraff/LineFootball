import SwiftUI
import WebKit

struct BrowseViewRepresentable: UIViewRepresentable {

    let url: URL
    let store: BrowseWebStore
    let configuration: BrowseConfiguration
    let navigationPolicy: BrowseNavigationPolicy

    func makeUIView(context: Context) -> WKWebView {
        let startTime = CFAbsoluteTimeGetCurrent()

        let webView = store.takePreparedWebView(matching: configuration)
            ?? BrowseViewFactory.makeBrowseView(
                frame: .zero,
                configuration: configuration,
                dataStore: BrowseViewFactory.makeDataStore(for: configuration)
            )
        let needsInitialLoad = webView.url != url

        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator

        if configuration.isZoomDisabled {
            webView.scrollView.delegate = context.coordinator
        }

        context.coordinator.webView = webView
        context.coordinator.loadedURL = url
        store.setWebView(webView, configuration: configuration)

        guard needsInitialLoad else {
            return webView
        }

        DispatchQueue.main.async { [weak webView, weak coordinator = context.coordinator] in
            guard let webView,
                  let coordinator,
                  coordinator.webView === webView,
                  coordinator.loadedURL == url else {
                return
            }

            webView.load(URLRequest(url: url))
        }

        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        guard store.isInitialized,
              context.coordinator.loadedURL != url else {
            return
        }

        context.coordinator.loadedURL = url
        webView.load(URLRequest(url: url))
    }

    func makeCoordinator() -> BrowseViewCoordinator {
        BrowseViewCoordinator(
            store: store,
            navigationPolicy: navigationPolicy
        )
    }

    static func dismantleUIView(
        _ webView: WKWebView,
        coordinator: BrowseViewCoordinator
    ) {
        coordinator.releaseManagedWebView(webView)
    }
}
