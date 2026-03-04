import Foundation
import Combine

enum SessionTab: Hashable {
    case feature1
    case feature2
    case feature3
    case feature4
}

@MainActor
protocol SessionCoordinatorElementsFactory:
    Feature1CoordinatorElementsFactory,
    Feature2CoordinatorElementsFactory,
    Feature3CoordinatorElementsFactory,
    Feature4CoordinatorElementsFactory {}

@MainActor
final class SessionCoordinator: ObservableObject {

    @Published var selectedTab: SessionTab = .feature1
    private let feature3Service: Feature3Service
    private let feature2Service: Feature2Service
    private let feature1Service: Feature1Service
    private let notificationsService: NotificationsService
    private let statisticsUrl: URL?
    private var hasRequestedNotifications = false

    init(feature3Service: Feature3Service, feature2Service: Feature2Service, feature1Service: Feature1Service, notificationsService: NotificationsService, statisticsUrl: URL?) {
        self.feature3Service = feature3Service
        self.feature2Service = feature2Service
        self.feature1Service = feature1Service
        self.notificationsService = notificationsService
        self.statisticsUrl = statisticsUrl
    }

    convenience init(  statisticsUrl: URL? = URL(
        string: "https://www.freeprivacypolicy.com/live/3b70cb69-e115-4f7a-ade7-dd70317583a0"
    )!) {
        self.init(feature3Service: Feature3Service(), feature2Service: Feature2Service(), feature1Service: Feature1Service(), notificationsService: NotificationsService(), statisticsUrl: statisticsUrl)
    }

    func buildFeature1Coordinator() -> Feature1Coordinator {
        Feature1Coordinator(
            navigation: Feature1CoordinatorNavigation(),
            elementsFactory: self
        )
    }

    func buildFeature2Coordinator() -> Feature2Coordinator {
        Feature2Coordinator(
            navigation: Feature2CoordinatorNavigation(),
            elementsFactory: self
        )
    }

    func buildFeature3Coordinator() -> Feature3Coordinator {
        Feature3Coordinator(
            navigation: Feature3CoordinatorNavigation(),
            elementsFactory: self
        )
    }
    
    func buildFeature4Coordinator() -> Feature4Coordinator {
        Feature4Coordinator(
            navigation: Feature4CoordinatorNavigation(),
            elementsFactory: self
        )
    }
}

extension SessionCoordinator: Feature1CoordinatorElementsFactory {
    func feature1VM() -> Feature1VM {
        Feature1VM(service: feature1Service)
    }

    func feature1DetailVM() -> Feature1DetailVM {
        Feature1DetailVM(service: feature1Service)
    }
}

extension SessionCoordinator: Feature2CoordinatorElementsFactory {
    func feature2VM() -> Feature2VM {
        Feature2VM(service: feature2Service)
    }

    func feature2DetailVM() -> Feature2DetailVM {
        Feature2DetailVM(service: feature2Service)
    }
}

extension SessionCoordinator: Feature3CoordinatorElementsFactory {
    func feature3VM() -> Feature3VM {
        Feature3VM(service: feature3Service)
    }

    func feature3DetailVM() -> Feature3DetailVM {
        Feature3DetailVM(service: feature3Service)
    }
}

extension SessionCoordinator: Feature4CoordinatorElementsFactory {
    func feature4VM() -> Feature4VM {
        Feature4VM()
    }
}
