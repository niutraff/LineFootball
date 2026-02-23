import Foundation

struct SettingsData: Identifiable {
    var id = UUID()
    var titel: String
    var link: URL
}

struct AppInfo {
    struct URLs {
        static let privacyLink = URL(string: "https://www.freeprivacypolicy.com/live/b7705891-8cec-4a3e-bb53-a001dd18d159")!
        static let termsLink = URL(string: "https://www.freeprivacypolicy.com/live/15d17f00-10b0-48b4-833e-fa87635849a8")!
    }
}


