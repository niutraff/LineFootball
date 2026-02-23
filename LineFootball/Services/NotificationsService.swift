import Foundation

struct BTPlayNotificationMessagesProvider: NotificationMessagesProviding {
    var messages: [NotificationMessage] {
        NotificationMessageKeys.all.map { keys in
            NotificationMessage(
                title: localized(keys.title),
                body: localized(keys.body)
            )
        }
    }

    private func localized(_ key: String) -> String {
        NSLocalizedString(key, bundle: .main, comment: "")
    }
}

@MainActor
final class NotificationsService {

    static let isTestMode = false

    private let controller: LocalNotificationsControlling

    init(controller: LocalNotificationsControlling = DefaultLocalNotificationsController(messagesProvider: BTPlayNotificationMessagesProvider())) {
        self.controller = controller
    }

    @discardableResult
    func requestAuthorization() async -> Bool {
        await controller.requestAuthorization()
    }

    func scheduleNotifications() async {
        if Self.isTestMode {
            await controller.scheduleTestNotifications()
        } else {
            await controller.scheduleDailyNotifications()
        }
    }

    func removeDailyNotifications() async {
        await controller.removeDailyNotifications()
    }
}

private enum NotificationMessageKeys {
    static let all: [(title: String, body: String)] = [
        ("notification.message1.title", "notification.message1.body"),
        ("notification.message2.title", "notification.message2.body"),
        ("notification.message3.title", "notification.message3.body"),
        ("notification.message4.title", "notification.message4.body"),
        ("notification.message5.title", "notification.message5.body"),
        ("notification.message6.title", "notification.message6.body"),
        ("notification.message7.title", "notification.message7.body"),
        ("notification.message8.title", "notification.message8.body"),
        ("notification.message9.title", "notification.message9.body"),
        ("notification.message10.title", "notification.message10.body"),
        ("notification.message11.title", "notification.message11.body"),
        ("notification.message12.title", "notification.message12.body"),
        ("notification.message13.title", "notification.message13.body"),
        ("notification.message14.title", "notification.message14.body"),
        ("notification.message15.title", "notification.message15.body"),
        ("notification.message16.title", "notification.message16.body"),
        ("notification.message17.title", "notification.message17.body"),
        ("notification.message18.title", "notification.message18.body"),
        ("notification.message19.title", "notification.message19.body"),
        ("notification.message20.title", "notification.message20.body")
    ]
}
