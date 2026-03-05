import Foundation

enum KeyValueStorageKey: String {
    case matchData = "match_data"
    case playerData = "player_data"
    case comandData = "comand_data"
    case seasonGoalTarget = "season_goal_target"
    case notificationAccepted = "notification_accepted"
    case notificationTestMode = "notification_test_mode"
}

protocol KeyValueStorable {
    func bool(forKey key: KeyValueStorageKey) -> Bool
    func string(forKey key: KeyValueStorageKey) -> String?
    func data(forKey key: KeyValueStorageKey) -> Data?
    func value<T>(forKey key: KeyValueStorageKey) -> T?
    func set(_ value: Any?, forKey key: KeyValueStorageKey)
    func remove(forKey key: KeyValueStorageKey)
}
