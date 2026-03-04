import Foundation

extension BrowseConfiguration {

    public static let `default` = BrowseConfiguration()

    public static let minimal = BrowseConfiguration(
        showsToolbar: false,
        showsLoadingIndicator: false
    )

    public static let full = BrowseConfiguration(
        showsToolbar: true,
        showsLoadingIndicator: true
    )

    public static func safariMobile(
        showsToolbar: Bool = true
    ) -> BrowseConfiguration {
        BrowseConfiguration(
            customUserAgent: "Mozilla/5.0 (iPhone; CPU iPhone OS 17_1_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.1.1 Mobile/15E148 Safari/604.1",
            isZoomDisabled: true,
            isBackgroundTransparent: true,
            showsToolbar: showsToolbar,
            showsLoadingIndicator: true
        )
    }
}
