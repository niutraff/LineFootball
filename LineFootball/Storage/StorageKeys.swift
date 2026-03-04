import Foundation

final class StorageKeys {

    static let shared = StorageKeys()

    private init() {}
    
    let notificationAccepted = StorageKey<Bool>(key: .notificationAccepted, default: false)
}
