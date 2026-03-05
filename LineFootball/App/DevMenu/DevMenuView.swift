#if DEBUG
import SwiftUI

struct DevMenuView: View {

    @KeyValue(\.notificationTestMode) private var isTestMode: Bool
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            List {
                Section("Notifications") {
                    Toggle(
                        "Test Mode (10-40s)",
                        isOn: Binding(
                            get: { isTestMode },
                            set: { isTestMode = $0 }
                        )
                    )
                }
            }
            .navigationTitle("Dev Menu")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
#endif
