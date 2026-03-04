import SwiftUI

struct Feature4View: View {

    @ObservedObject var viewModel: Feature4VM

    var body: some View {
        VStack {
            Text("settings.title".localized())
                .bold()
                .font(.largeTitle)
                .foregroundStyle(Color.palette(.white))
                .padding(.leading, 16)
                .frame(height: 80)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.palette(.darkGreenColor))
            
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    settingsRow(title: "settings.rate".localized()) {
                        viewModel.onRateUsTapped()
                    }

                    separator
                    
                    settingsRow(title: "settings.privacyPolicy".localized()) {
                        viewModel.onPrivacyPolicyTapped()
                    }

                    separator

                    settingsRow(title: "settings.termsOfUse".localized()) {
                        viewModel.onTermsOfUseTapped()
                    }
                }
                .background(Color.palette(.white))
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .padding(.horizontal, 16)
                .padding(.top, 21)

                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.palette(.backColor))
    }
    
    private func settingsRow(title: String, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            HStack {
                Text(title)
                    .font(.custom(FontFamily.regular, size: 17))
                    .foregroundColor(.black)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color.palette(.grayColor))
            }
            .padding(.horizontal, 16)
            .frame(height: 56)
        }
        .buttonStyle(.plain)
    }

    private var separator: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.4))
            .frame(height: 1)
            .padding(.leading, 16)
    }
}

#Preview {
    NavigationStack {
        Feature4View(viewModel: Feature4VM())
    }
}
