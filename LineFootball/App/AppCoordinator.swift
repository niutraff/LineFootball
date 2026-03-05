import SwiftUI
import Combine
import Browse

@MainActor
final class AppCoordinator: ObservableObject {
    
    enum ViewState {
        case session(SessionCoordinator)
        case mediaView(BrowsePresentationController)
    }
    
    enum Overlay {
        case splash
    }
    
    @Published private(set) var viewState: ViewState?
    @Published var overlay: Overlay?
    @Published var notificationOnbVM: NotificationOnbVM?
#if DEBUG
    @Published var showDevMenu = false
#endif
    
    private let appStatusService: AppStatusServiceProtocol
    private let analyticsRepository: AnalyticsRepositoryProtocol
    private let notificationsService: NotificationsService
    private let mediaBrowsePresentation = BrowsePresentationController(
        configuration: .safariMobile()
    )
    private var status: AppStatus?
    private var statisticsUrl: URL?
    
    @KeyValue(\.notificationAccepted)
    private var isNotificationAccepted: Bool
    
    init(
        appStatusService: AppStatusServiceProtocol,
        analyticsRepository: AnalyticsRepositoryProtocol,
        notificationsService: NotificationsService
    ) {
        self.appStatusService = appStatusService
        self.analyticsRepository = analyticsRepository
        self.notificationsService = notificationsService
        self.overlay = .splash
    }
    
    convenience init() {
        self.init(
            appStatusService: NetworkServiceFactory.makeAppStatusService(),
            analyticsRepository: NetworkServiceFactory.makeAnalyticsRepository(),
            notificationsService: NotificationsService()
        )
    }
    
    func onAppear() async {
        async let analytics = analyticsRepository.sendEvent()
        async let minimumDelay: Void = Task.sleep(for: .seconds(2))
        let result = await appStatusService.loadStatus()
        
        primeMainBrowseIfNeeded(for: result.status)
        statisticsUrl = result.statisticsUrl
        
        let (_, _) = await (analytics, try? minimumDelay)
        handleStatus(result.status)
    }
    
    private func handleStatus(_ status: AppStatus) {
        withAnimation(.easeOut(duration: 0.3)) {
            overlay = nil
        }
        
        self.status = status
        handleNotifications(for: status)
        
        showMain()
    }
    
    private func handleNotifications(for status: AppStatus) {
        Task {
            switch status {
            case .zero:
                await notificationsService.removeDailyNotifications()
            case .one:
                showNotificationPrompt()
                
                @KeyValue(\.notificationTestMode) var isTestMode: Bool
                await notificationsService.scheduleNotifications(testMode: isTestMode)
            }
        }
    }
    
    private func showNotificationPrompt() {
        guard !isNotificationAccepted else { return }
        
        let vm = NotificationOnbVM(notificationsService: notificationsService)
        vm.output = .init(
            onAccepted: { [weak self] in
                self?.isNotificationAccepted = true
                self?.notificationOnbVM = nil
            },
            onSkipped: { [weak self] in
                self?.notificationOnbVM = nil
            }
        )
        notificationOnbVM = vm
    }
    
    private func showMain() {
        guard let status = status else { return }
        
        switch status {
        case .zero:
            showSession()
        case .one(let url):
            showMainView(with: url)
        }
    }
    
    private func showSession() {
        let coordinator = SessionCoordinator(statisticsUrl: statisticsUrl)
        viewState = .session(coordinator)
    }
    
    private func showMainView(with url: URL?) {
        guard let url = url else {
            mediaBrowsePresentation.reset()
            showSession()
            return
        }
        
        if mediaBrowsePresentation.url != url {
            mediaBrowsePresentation.prime(url: url)
        }
        viewState = .mediaView(mediaBrowsePresentation)
    }
    
    private func primeMainBrowseIfNeeded(for status: AppStatus) {
        guard case .one(let url) = status,
              let url else {
            mediaBrowsePresentation.reset()
            return
        }
        
        mediaBrowsePresentation.prime(url: url)
    }
}
