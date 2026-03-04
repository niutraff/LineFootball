import SwiftUI

struct ExternalBrowseViewSheetModifier: ViewModifier {

    @ObservedObject var store: BrowseWebStore
    @ObservedObject var externalStore: BrowseWebStore
    let configuration: BrowseConfiguration
    let closeButtonTitle: String

    func body(content: Content) -> some View {
        content.sheet(
            isPresented: Binding(
                get: { store.externalBrowseViewURL != nil },
                set: { if !$0 { store.externalBrowseViewURL = nil } }
            )
        ) {
            if let url = store.externalBrowseViewURL {
                NavigationStack {
                    BrowseViewRepresentable(
                        url: url,
                        store: externalStore,
                        configuration: externalConfiguration,
                        navigationPolicy: DefaultNavigationPolicy()
                    )
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(closeButtonTitle) {
                                store.externalBrowseViewURL = nil
                            }
                        }
                    }
                }
            }
        }
    }

    private var externalConfiguration: BrowseConfiguration {
        BrowseConfiguration(
            customUserAgent: configuration.customUserAgent,
            isZoomDisabled: configuration.isZoomDisabled,
            isBackgroundTransparent: configuration.isBackgroundTransparent,
            showsToolbar: false,
            showsLoadingIndicator: false,
            usesEphemeralStorage: configuration.usesEphemeralStorage
        )
    }
}


extension View {
    func externalBrowseViewSheet(
        store: BrowseWebStore,
        externalStore: BrowseWebStore,
        configuration: BrowseConfiguration,
        closeButtonTitle: String = "Close"
    ) -> some View {
        modifier(ExternalBrowseViewSheetModifier(
            store: store,
            externalStore: externalStore,
            configuration: configuration,
            closeButtonTitle: closeButtonTitle
        ))
    }
}
