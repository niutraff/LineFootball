import Foundation

enum EncodedNotificationMessages {

    // MARK: - English (fallback)

    static let en: [(title: String, body: String)] = [
        ("Qm9udXMgSW5zaWRlIPCfjoE=", "RGVwb3NpdCBub3cgYW5kIGNsYWltIHlvdXIgcmV3YXJkLg=="),
        ("RXh0cmEgQm9vc3Qg4pqh", "VG9wIHVwIGFuZCBwbGF5IHdpdGggYm9udXMgZnVuZHMu"),
        ("TmV3IEJvbnVzIPCfjok=", "WW91ciBkZXBvc2l0IHJld2FyZCBpcyByZWFkeS4="),
        ("V2UgTWlzcyBZb3Ug8J+RgA==", "Q29tZSBiYWNrIGFuZCBzZWUgd2hhdCdzIG5ldy4="),
        ("QmFjayBUbyBQbGF5IPCfjq4=", "VGhlIGFjdGlvbiBpcyB3YWl0aW5nIGZvciB5b3Uu")
    ]

    // MARK: - Spanish

    static let es: [(title: String, body: String)] = [
        ("Qm9ubyBEZW50cm8g8J+OgQ==", "RGVwb3NpdGEgYWhvcmEgeSByZWNsYW1hIHR1IHJlY29tcGVuc2Eu"),
        ("SW1wdWxzbyBFeHRyYSDimqE=", "UmVjYXJnYSB5IGp1ZWdhIGNvbiBmb25kb3MgZGUgYm9uby4="),
        ("TnVldm8gQm9ubyDwn46J", "VHUgcmVjb21wZW5zYSBwb3IgZGVww7NzaXRvIGVzdMOhIGxpc3RhLg=="),
        ("VGUgRXh0cmHDsWFtb3Mg8J+RgA==", "VnVlbHZlIHkgZGVzY3VicmUgbG8gbnVldm8u"),
        ("VnVlbHZlIGEgSnVnYXIg8J+Org==", "TGEgYWNjacOzbiB0ZSBlc3TDoSBlc3BlcmFuZG8u")
    ]

    // MARK: - French

    static let fr: [(title: String, body: String)] = [
        ("Qm9udXMgw6AgbCdJbnTDqXJpZXVyIPCfjoE=", "RMOpcG9zZXogbWFpbnRlbmFudCBldCByZWNldmV6IHZvdHJlIHLDqWNvbXBlbnNlLg=="),
        ("Qm9vc3QgU3VwcGzDqW1lbnRhaXJlIOKaoQ==", "UmVjaGFyZ2V6IGV0IGpvdWV6IGF2ZWMgZGVzIGZvbmRzIGJvbnVzLg=="),
        ("Tm91dmVhdSBCb251cyDwn46J", "Vm90cmUgcsOpY29tcGVuc2UgZGUgZMOpcMO0dCBlc3QgcHLDqnRlLg=="),
        ("Vm91cyBOb3VzIE1hbnF1ZXog8J+RgA==", "UmV2ZW5leiB2b2lyIGxlcyBub3V2ZWF1dMOpcy4="),
        ("UmV0b3VyIGF1IEpldSDwn46u", "TCdhY3Rpb24gdm91cyBhdHRlbmQu")
    ]

    // MARK: - German

    static let de: [(title: String, body: String)] = [
        ("Qm9udXMgSW5uZW4g8J+OgQ==", "SmV0enQgZWluemFobGVuIHVuZCBkZWluZSBCZWxvaG51bmcgZXJoYWx0ZW4u"),
        ("RXh0cmEgQm9vc3Qg4pqh", "TGFkZSBhdWYgdW5kIHNwaWVsZSBtaXQgQm9udXNnZWxkLg=="),
        ("TmV1ZXIgQm9udXMg8J+OiQ==", "RGVpbmUgRWluemFobHVuZ3NiZWxvaG51bmcgaXN0IGJlcmVpdC4="),
        ("V2lyIFZlcm1pc3NlbiBEaWNoIPCfkYA=", "S29tbSB6dXLDvGNrIHVuZCBzaWVoLCB3YXMgZXMgTmV1ZXMgZ2lidC4="),
        ("WnVyw7xjayB6dW0gU3BpZWwg8J+Org==", "RGllIEFjdGlvbiB3YXJ0ZXQgYXVmIGRpY2gu")
    ]

    // MARK: - Arabic

    static let ar: [(title: String, body: String)] = [
        ("2YXZg9in2YHYo9ipINio2KfZhNiv2KfYrtmEIPCfjoE=", "2YLZhSDYqNin2YTYpdmK2K/Yp9i5INin2YTYotmGINmI2KfYrdi12YQg2LnZhNmJINmF2YPYp9mB2KPYqtmDLg=="),
        ("2K/Zgdi52Kkg2KXYttin2YHZitipIOKaoQ==", "2KPYttmBINix2LXZitiv2YvYpyDZiNin2YTYudioINio2KPZhdmI2KfZhCDYp9mE2KjZiNmG2LUu"),
        ("2KjZiNmG2LUg2KzYr9mK2K8g8J+OiQ==", "2YXZg9in2YHYo9ipINin2YTYpdmK2K/Yp9i5INin2YTYrtin2LXYqSDYqNmDINis2KfZh9iy2Kku"),
        ("2YbZgdiq2YLYr9mDIPCfkYA=", "2LnYryDZiNin2YPYqti02YEg2YXYpyDYp9mE2KzYr9mK2K8u"),
        ("2KfZhNi52YjYr9ipINmE2YTYudioIPCfjq4=", "2KfZhNil2KvYp9ix2Kkg2KjYp9mG2KrYuNin2LHZgy4=")
    ]

    // MARK: - Language Resolution

    static let supportedLanguages = ["en", "es", "fr", "de", "ar"]

    static func messages(for languageCode: String) -> [(title: String, body: String)] {
        switch languageCode {
        case "es": return es
        case "fr": return fr
        case "de": return de
        case "ar": return ar
        case "en": return en
        default: return en
        }
    }
}
