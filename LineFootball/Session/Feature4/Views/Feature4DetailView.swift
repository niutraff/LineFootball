import SwiftUI
import Browse

struct Feature4DetailView: View {
    @ObservedObject var viewModel: Feature4DetailVM
    
    var body: some View {
        VStack {
            BrowseView(
                url: viewModel.url,
                configuration: .minimal
            )
            .padding(.top, 30)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.palette(.backColor))
        .navigationView(
            title: viewModel.title,
            showsBackButton: true,
            onBackButtonTap: {
                DispatchQueue.main.async {
                    viewModel.onBackTapped()
                }
            }
        )
    }
}

