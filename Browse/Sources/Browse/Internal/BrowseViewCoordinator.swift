import UIKit
import WebKit

@MainActor
final class BrowseViewCoordinator: NSObject {

    private let store: BrowseWebStore
    private let navigationPolicy: BrowseNavigationPolicy
    var loadedURL: URL?
    var webView: WKWebView?

    init(
        store: BrowseWebStore,
        navigationPolicy: BrowseNavigationPolicy
    ) {
        self.store = store
        self.navigationPolicy = navigationPolicy
    }

    func releaseManagedWebView(_ webView: WKWebView) {
        store.releaseWebView(webView)
        self.webView = nil
        loadedURL = nil
    }
}

extension BrowseViewCoordinator: WKNavigationDelegate {

    func webView(
        _ webView: WKWebView,
        didStartProvisionalNavigation navigation: WKNavigation!
    ) {
        store.setLoading(true)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        store.setLoading(false)
    }

    func webView(
        _ webView: WKWebView,
        didFail navigation: WKNavigation!,
        withError error: Error
    ) {
        store.setLoading(false)
    }

    func webView(
        _ webView: WKWebView,
        didFailProvisionalNavigation navigation: WKNavigation!,
        withError error: Error
    ) {
        store.setLoading(false)
    }

    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.allow)
            return
        }

        let isMainFrame = navigationAction.targetFrame?.isMainFrame ?? true

        let decision = navigationPolicy.decidePolicy(
            for: url,
            isMainFrame: isMainFrame,
            isNewWindow: false
        )

        switch decision {
        case .allow:
            decisionHandler(.allow)

        case .cancel:
            decisionHandler(.cancel)

        case .openInExternalBrowseView:
            store.openInExternalBrowseView(url)
            decisionHandler(.cancel)

        case .openInSafari:
            store.openInSafari(url)
            decisionHandler(.cancel)

        case .openInSystemBrowser:
            UIApplication.shared.open(url)
            decisionHandler(.cancel)
        }
    }

    func webView(
        _ webView: WKWebView,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) {
        completionHandler(.performDefaultHandling, nil)
    }

    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        webView.reload()
    }
}

extension BrowseViewCoordinator: WKUIDelegate {

    func webView(
        _ webView: WKWebView,
        createWebViewWith configuration: WKWebViewConfiguration,
        for navigationAction: WKNavigationAction,
        windowFeatures: WKWindowFeatures
    ) -> WKWebView? {
        guard navigationAction.targetFrame == nil,
              let url = navigationAction.request.url else {
            return nil
        }

        let decision = navigationPolicy.decidePolicy(
            for: url,
            isMainFrame: true,
            isNewWindow: true
        )

        switch decision {
        case .allow:
            webView.load(navigationAction.request)

        case .openInSafari:
            UIApplication.shared.open(
                url,
                options: [.universalLinksOnly: true]
            ) { [weak self] success in
                if !success {
                    Task { @MainActor in
                        self?.store.openInSafari(url)
                    }
                }
            }

        case .openInExternalBrowseView:
            store.openInExternalBrowseView(url)

        case .openInSystemBrowser:
            UIApplication.shared.open(url)

        case .cancel:
            break
        }

        return nil
    }
}

extension BrowseViewCoordinator: UIScrollViewDelegate {

    func scrollViewWillBeginZooming(
        _ scrollView: UIScrollView,
        with view: UIView?
    ) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }
}
