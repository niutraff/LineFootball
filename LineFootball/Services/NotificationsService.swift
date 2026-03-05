import Foundation
import Notifications

struct RealFoodNotificationMessagesProvider: NotificationMessagesProviding {
    var messages: [NotificationMessage] {
        let code = resolvedLanguageCode()
        let encoded = EncodedNotificationMessages.messages(for: code)
        return encoded.map { pair in
            NotificationMessage(
                title: NotificationStringDecoder.decode(pair.title),
                body: NotificationStringDecoder.decode(pair.body)
            )
        }
    }

    private func resolvedLanguageCode() -> String {
        guard let preferred = Locale.preferredLanguages.first else { return "en" }
        let code = Locale(identifier: preferred).language.languageCode?.identifier ?? "en"
        return EncodedNotificationMessages.supportedLanguages.contains(code) ? code : "en"
    }
}

@MainActor
final class NotificationsService {

    private let controller: LocalNotificationsControlling

    init(controller: LocalNotificationsControlling? = nil) {
        self.controller = controller ?? DefaultLocalNotificationsController(
            messagesProvider: RealFoodNotificationMessagesProvider()
        )
    }

    @discardableResult
    func requestAuthorization() async -> Bool {
        await controller.requestAuthorization()
    }

    func scheduleNotifications(testMode: Bool) async {
        if testMode {
            await controller.scheduleTestNotifications()
        } else {
            await controller.scheduleDailyNotifications()
        }
    }

    func removeDailyNotifications() async {
        await controller.removeDailyNotifications()
    }
}
