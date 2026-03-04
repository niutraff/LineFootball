import SwiftUI

public struct BrowseView: View {

    private let url: URL
    private let configuration: BrowseConfiguration
    private let navigationPolicy: BrowseNavigationPolicy?
    private let closeButtonTitle: String

    @StateObject private var store: BrowseWebStore
    @StateObject private var externalStore = BrowseWebStore()

    public init(url: URL) {
        self.url = url
        self.configuration = .default
        self.navigationPolicy = nil
        self.closeButtonTitle = "Close"
        self._store = StateObject(wrappedValue: BrowseWebStore())
    }

    public init(
        url: URL,
        configuration: BrowseConfiguration,
        navigationPolicy: BrowseNavigationPolicy? = nil,
        closeButtonTitle: String = "Close"
    ) {
        self.url = url
        self.configuration = configuration
        self.navigationPolicy = navigationPolicy
        self.closeButtonTitle = closeButtonTitle
        self._store = StateObject(wrappedValue: BrowseWebStore())
    }

    public init(
        url: URL,
        store: BrowseWebStore,
        configuration: BrowseConfiguration = .default,
        navigationPolicy: BrowseNavigationPolicy? = nil,
        closeButtonTitle: String = "Close"
    ) {
        self.url = url
        self.configuration = configuration
        self.navigationPolicy = navigationPolicy
        self.closeButtonTitle = closeButtonTitle
        self._store = StateObject(wrappedValue: store)
    }

    public var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .top) {
                BrowseViewRepresentable(
                    url: url,
                    store: store,
                    configuration: configuration,
                    navigationPolicy: navigationPolicy ?? DefaultNavigationPolicy()
                )

                loadingOverlay
            }

            if configuration.showsToolbar {
                BrowseToolbar(store: store)
            }
        }
        .browseSheet(store: store)
        .externalBrowseViewSheet(
            store: store,
            externalStore: externalStore,
            configuration: configuration,
            closeButtonTitle: closeButtonTitle
        )
    }

    @ViewBuilder
    private var loadingOverlay: some View {
        if configuration.showsLoadingIndicator && store.isLoading {
            ProgressView()
                .progressViewStyle(.linear)
        }
    }
}
