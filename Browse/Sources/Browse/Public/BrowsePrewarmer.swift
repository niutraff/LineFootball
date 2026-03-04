import Foundation

public final class BrowsePrewarmer: @unchecked Sendable {

    private var warmStore: BrowseWebStore?
    private var warmConfiguration: BrowseConfiguration?

    public init() {}

    @MainActor
    public func warmUp(
        configuration: BrowseConfiguration = .default
    ) {
        let start = CFAbsoluteTimeGetCurrent()

        if warmConfiguration != configuration {
            warmStore = nil
        }

        if warmStore == nil {
            let store = BrowseWebStore()
            store.prepareForPresentation(configuration: configuration)
            warmStore = store
            warmConfiguration = configuration
        }

        let elapsed = (CFAbsoluteTimeGetCurrent() - start) * 1000
    }

    @MainActor
    public func takeStore(
        matching configuration: BrowseConfiguration = .default
    ) -> BrowseWebStore? {
        guard warmConfiguration == configuration else { return nil }

        let store = warmStore
        warmStore = nil
        warmConfiguration = nil
        return store
    }
}
