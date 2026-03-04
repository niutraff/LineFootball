import WebKit

enum BrowseViewFactory {

    static let sharedProcessPool = WKProcessPool()
    static let sharedEphemeralDataStore: WKWebsiteDataStore = .nonPersistent()

    static func makeDataStore(
        for configuration: BrowseConfiguration
    ) -> WKWebsiteDataStore {
        configuration.usesEphemeralStorage
            ? sharedEphemeralDataStore
            : .default()
    }

    static func makeBrowseView(
        frame: CGRect,
        configuration: BrowseConfiguration,
        dataStore: WKWebsiteDataStore
    ) -> WKWebView {
        let wkConfig = WKWebViewConfiguration()
        wkConfig.processPool = Self.sharedProcessPool
        wkConfig.websiteDataStore = dataStore
        wkConfig.preferences.javaScriptCanOpenWindowsAutomatically = true
        wkConfig.allowsInlineMediaPlayback = true
        wkConfig.mediaTypesRequiringUserActionForPlayback = []

        if configuration.isZoomDisabled {
            let script = WKUserScript(
                source: ZoomDisableScript.source,
                injectionTime: .atDocumentEnd,
                forMainFrameOnly: true
            )
            wkConfig.userContentController.addUserScript(script)
        }

        let webView = WKWebView(frame: frame, configuration: wkConfig)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.allowsBackForwardNavigationGestures = true

        if let userAgent = configuration.customUserAgent {
            webView.customUserAgent = userAgent
        }

        if configuration.isBackgroundTransparent {
            webView.isOpaque = false
            webView.backgroundColor = .clear
            webView.scrollView.backgroundColor = .clear
        }

        return webView
    }
}
