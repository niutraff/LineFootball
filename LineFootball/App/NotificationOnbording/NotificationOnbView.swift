import SwiftUI

struct NotificationOnbView: View {
    @ObservedObject var viewModel: NotificationOnbVM
    
    var body: some View {
        VStack {
            Image(.logo)
                .padding(.top, 24)
            
            VStack(spacing: 10) {
                Text("notification.onbr.title".localized())
                    .bold()
                    .font(.largeTitle)
                    .foregroundStyle(Color.palette(.black900))
                    .multilineTextAlignment(.center)
                
                Text("notification.onbr.description".localized())
                    .typography(.body.regular)
                    .foregroundStyle(Color.palette(.black900))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            .padding(.top, UIScreen.main.bounds.height / 5)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.palette(.backColor))
        .overlay(alignment: .top, content: {
            Color.palette(.darkGreenColor).frame(height: 80).ignoresSafeArea()
        })
        .overlay(alignment: .bottom) {
            VStack(spacing: 20) {
                Button {
                    viewModel.onSkipTapped()
                } label: {
                    Text("notification.onbr.skip".localized())
                        .typography(.body.semibold)
                        .foregroundStyle(Color.palette(.greenColor))
                }
                
                Button {
                    viewModel.onAcceptTapped()
                } label: {
                    Text("notification.onbr.agree".localized())
                        .typography(.body.semibold)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.palette(.greenColor))
                        .cornerRadius(26)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 48)
            }
        }
    }
}

#Preview {
    NotificationOnbView(viewModel: .init())
}
