import Foundation
import Combine
import WebKit

@MainActor
public final class BrowseWebStore: ObservableObject {

    @Published public private(set) var canGoBack: Bool = false

    @Published public private(set) var canGoForward: Bool = false

    @Published public private(set) var currentURL: URL?

    @Published public private(set) var isLoading: Bool = false

    @Published public private(set) var isInitialized: Bool = false

    @Published public var safariURL: URL?

    @Published public var externalBrowseViewURL: URL?

    private var webView: WKWebView?
    private var preparedWebView: WKWebView?
    private var activeConfiguration: BrowseConfiguration?
    private var preparedConfiguration: BrowseConfiguration?
    private var observations: [NSKeyValueObservation] = []

    public init() {}

    deinit {
        observations.removeAll()
    }

    public func prepareForPresentation(
        configuration: BrowseConfiguration
    ) {
        guard webView == nil else { return }

        if let preparedConfiguration,
           preparedConfiguration == configuration,
           preparedWebView != nil {
            return
        }

        preparedWebView = BrowseViewFactory.makeBrowseView(
            frame: .zero,
            configuration: configuration,
            dataStore: BrowseViewFactory.makeDataStore(for: configuration)
        )
        self.preparedConfiguration = configuration
    }

    public func goBack() {
        webView?.goBack()
    }

    public func goForward() {
        webView?.goForward()
    }

    public func reload() {
        webView?.reload()
    }

    public func load(_ url: URL) {
        webView?.load(URLRequest(url: url))
    }

    public func stopLoading() {
        webView?.stopLoading()
    }

    func setWebView(
        _ webView: WKWebView,
        configuration: BrowseConfiguration
    ) {
        self.webView = webView
        activeConfiguration = configuration
        preparedWebView = nil
        preparedConfiguration = nil
        setupObservations(for: webView)
        // Отложенная публикация: makeUIView/updateUIView вызываются во время view update.
        DispatchQueue.main.async { [weak self] in
            self?.isInitialized = true
        }
    }

    func setLoading(_ value: Bool) {
        isLoading = value
    }

    func openInSafari(_ url: URL) {
        safariURL = url
    }

    func openInExternalBrowseView(_ url: URL) {
        externalBrowseViewURL = url
    }

    func takePreparedWebView(
        matching configuration: BrowseConfiguration
    ) -> WKWebView? {
        guard let preparedConfiguration,
              preparedConfiguration == configuration else {
            preparedWebView = nil
            self.preparedConfiguration = nil
            return nil
        }

        let webView = preparedWebView
        preparedWebView = nil
        self.preparedConfiguration = nil
        return webView
    }

    func releaseWebView(_ webView: WKWebView) {
        guard self.webView === webView else { return }

        observations.removeAll()

        webView.navigationDelegate = nil
        webView.uiDelegate = nil
        webView.scrollView.delegate = nil

        preparedWebView = webView
        preparedConfiguration = activeConfiguration

        self.webView = nil
        activeConfiguration = nil

        // Отложенная публикация: не менять @Published во время view update (dismantleUIView),
        // иначе "Publishing changes from within view updates" и одновременный доступ.
        DispatchQueue.main.async { [weak self] in
            self?.isInitialized = false
            self?.isLoading = false
        }
    }

    private func setupObservations(for webView: WKWebView) {
        observations.removeAll()

        observations.append(
            webView.observe(\.canGoBack, options: [.new]) { [weak self] webView, _ in
                if Thread.isMainThread {
                    self?.canGoBack = webView.canGoBack
                } else {
                    Task { @MainActor [weak self] in
                        self?.canGoBack = webView.canGoBack
                    }
                }
            }
        )

        observations.append(
            webView.observe(\.canGoForward, options: [.new]) { [weak self] webView, _ in
                if Thread.isMainThread {
                    self?.canGoForward = webView.canGoForward
                } else {
                    Task { @MainActor [weak self] in
                        self?.canGoForward = webView.canGoForward
                    }
                }
            }
        )

        observations.append(
            webView.observe(\.isLoading, options: [.new]) { [weak self] webView, _ in
                if Thread.isMainThread {
                    self?.isLoading = webView.isLoading
                } else {
                    Task { @MainActor [weak self] in
                        self?.isLoading = webView.isLoading
                    }
                }
            }
        )

        observations.append(
            webView.observe(\.url, options: [.new]) { [weak self] webView, _ in
                if Thread.isMainThread {
                    self?.currentURL = webView.url
                } else {
                    Task { @MainActor [weak self] in
                        self?.currentURL = webView.url
                    }
                }
            }
        )
    }
}
