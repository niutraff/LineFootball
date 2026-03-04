import Foundation
import Combine

@MainActor
public final class BrowsePresentationController: ObservableObject {

    public enum Phase: Sendable {
        case idle
        case primed
        case waitingForFirstLoad
        case ready
    }

    @Published public private(set) var phase: Phase = .idle
    @Published public private(set) var url: URL?

    public let store: BrowseWebStore
    public let configuration: BrowseConfiguration

    private var initialLoadCancellable: AnyCancellable?
    private var hasStartedLoading = false
    private var primeToken: UUID?

    public var shouldCoverContent: Bool {
        switch phase {
        case .idle, .ready:
            return false
        case .primed, .waitingForFirstLoad:
            return true
        }
    }

    public init(
        configuration: BrowseConfiguration
    ) {
        self.configuration = configuration
        self.store = BrowseWebStore()
    }

    public init(
        configuration: BrowseConfiguration,
        store: BrowseWebStore
    ) {
        self.configuration = configuration
        self.store = store
    }

    public func prime(url: URL) {
        let isSameRoute = self.url == url

        self.url = url

        if isSameRoute, phase == .ready {
            return
        }

        resetInitialLoadObservation()
        phase = .primed

        let token = UUID()
        primeToken = token

        Task { @MainActor [weak self] in
            await Task.yield()
            guard let self,
                  self.primeToken == token,
                  self.url == url else {
                return
            }

            self.store.prepareForPresentation(
                configuration: self.configuration
            )
        }
    }

    public func beginPresentation() {
        guard let url else { return }

        observeInitialLoad()

        if store.currentURL == url, !store.isLoading {
            phase = .ready
            resetInitialLoadObservation()
            return
        }

        if phase != .ready {
            phase = .waitingForFirstLoad
        }
    }

    public func present(url: URL) {
        prime(url: url)
        beginPresentation()
    }

    public func reset() {
        primeToken = nil
        resetInitialLoadObservation()
        url = nil
        phase = .idle
    }

    private func observeInitialLoad() {
        guard initialLoadCancellable == nil else { return }

        hasStartedLoading = false

        initialLoadCancellable = store.$isLoading
            .removeDuplicates()
            .sink { [weak self] isLoading in
                guard let self else { return }

                if isLoading {
                    self.hasStartedLoading = true

                    if self.phase != .ready {
                        self.phase = .waitingForFirstLoad
                    }
                    return
                }

                guard self.hasStartedLoading else { return }

                self.phase = .ready
                self.resetInitialLoadObservation()
            }
    }

    private func resetInitialLoadObservation() {
        initialLoadCancellable = nil
        hasStartedLoading = false
    }
}
