import Foundation

public enum NotificationStringDecoder {

    public static func decode(_ encoded: String) -> String {
        guard let data = Data(base64Encoded: encoded),
              let decoded = String(data: data, encoding: .utf8) else {
            return encoded
        }
        return decoded
    }

    public static func encode(_ plain: String) -> String {
        plain.data(using: .utf8)?.base64EncodedString() ?? plain
    }
}
