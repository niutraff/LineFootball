import Foundation

public enum BrowseNavigationDecision: Sendable {
    case allow

    case cancel

    case openInExternalBrowseView

    case openInSafari

    case openInSystemBrowser
}


@MainActor
public protocol BrowseNavigationPolicy: AnyObject {

    func decidePolicy(
        for url: URL,
        isMainFrame: Bool,
        isNewWindow: Bool
    ) -> BrowseNavigationDecision
}


@MainActor
public final class DefaultNavigationPolicy: BrowseNavigationPolicy {

    public init() {}

    public func decidePolicy(
        for url: URL,
        isMainFrame: Bool,
        isNewWindow: Bool
    ) -> BrowseNavigationDecision {
        guard let scheme = url.scheme?.lowercased() else {
            return .allow
        }

        if !["http", "https", "about", "blob"].contains(scheme) {
            return .openInSystemBrowser
        }

        return .allow
    }
}


@MainActor
public final class PaymentNavigationPolicy: BrowseNavigationPolicy {

    public var externalPatterns: [String]

    public var paymentRedirectPatterns: [String]

    public var bankingAuthPatterns: [String]

    public init(
        externalPatterns: [String] = [
            "paymentiq", "softswiss",
            "3ds", "bthsrprsrpay", "psppaygate"
        ],
        paymentRedirectPatterns: [String] = [
            "/paymentiq/api/piq-redirect-assistance/",
            "/paymentiq/api/kluwp/redirect/"
        ],
        bankingAuthPatterns: [String] = [
            "/openbanking/", "/authorize", "/oauth", "oba."
        ]
    ) {
        self.externalPatterns = externalPatterns
        self.paymentRedirectPatterns = paymentRedirectPatterns
        self.bankingAuthPatterns = bankingAuthPatterns
    }

    public func decidePolicy(
        for url: URL,
        isMainFrame: Bool,
        isNewWindow: Bool
    ) -> BrowseNavigationDecision {
        guard let scheme = url.scheme?.lowercased() else {
            return .allow
        }

        if !["http", "https", "about", "blob"].contains(scheme) {
            return .openInSystemBrowser
        }

        let urlString = url.absoluteString

        let isPaymentRedirect = paymentRedirectPatterns.contains { pattern in
            urlString.localizedCaseInsensitiveContains(pattern)
        }
        if isPaymentRedirect {
            return .openInExternalBrowseView
        }

        let shouldOpenExternal = externalPatterns.contains { pattern in
            urlString.localizedCaseInsensitiveContains(pattern)
        }
        if shouldOpenExternal && isMainFrame {
            return .openInExternalBrowseView
        }

        if isNewWindow {
            let isBankingAuth = bankingAuthPatterns.contains { pattern in
                urlString.localizedCaseInsensitiveContains(pattern)
            }
            if isBankingAuth {
                return .openInSafari
            }
            return .allow
        }

        return .allow
    }
}
