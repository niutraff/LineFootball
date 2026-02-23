import UIKit

enum PlayerPhotoStorage {
    static func saveImage(_ image: UIImage, filename: String) -> Bool {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return false }
        let url = documentsURL(filename: filename)
        do {
            try data.write(to: url)
            return true
        } catch {
            return false
        }
    }

    static func loadImage(filename: String) -> UIImage? {
        let url = documentsURL(filename: filename)
        guard FileManager.default.fileExists(atPath: url.path) else { return nil }
        return UIImage(contentsOfFile: url.path)
    }

    static func documentsURL(filename: String) -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(filename)
    }

    static func filename(forPlayerId id: String) -> String {
        "player_\(id).jpg"
    }
}
