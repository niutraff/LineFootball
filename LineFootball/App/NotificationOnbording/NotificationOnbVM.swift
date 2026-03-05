import SwiftUI
import Combine

@MainActor
final class NotificationOnbVM: ObservableObject, Identifiable {

    struct Output {
        let onAccepted: () -> Void
        let onSkipped: () -> Void
    }

    var output: Output?

    private let notificationsService: NotificationsService

    init(notificationsService: NotificationsService) {
        self.notificationsService = notificationsService
    }

    convenience init() {
        self.init(notificationsService: NotificationsService())
    }

    func onAcceptTapped() {
        Task {
            let granted = await notificationsService.requestAuthorization()
            if granted {
                @KeyValue(\.notificationTestMode) var isTestMode: Bool
                await notificationsService.scheduleNotifications(testMode: isTestMode)
            }
            output?.onAccepted()
        }
    }

    func onSkipTapped() {
        output?.onSkipped()
    }
}
