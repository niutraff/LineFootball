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
            
            VStack {
                ForEach(viewModel.settings) { item in
                    Button {
                        viewModel.openWebView(with: item.link)
                    } label: {
                        HStack {
                            Text(item.titel)
                                .foregroundStyle(Color.palette(.black900))
                                .padding(.horizontal)
                                .padding(.top, 10)
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundStyle(Color.gray)
                                .padding(.trailing)
                        }
                        .frame(height: 44)
                    }
                    .frame(maxWidth: .infinity)
                    
                    Color.gray.opacity(0.4).frame(height: 1).frame(maxWidth: .infinity)
                        .padding(.leading)
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color.palette(.white))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(content: {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(lineWidth: 1).fill(Color.palette(.borderColor))
            })
            .padding(.horizontal)
            .padding(.top, 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.palette(.backColor))
        .fullScreenCover(isPresented: $viewModel.showWebView) {
            if let url = viewModel.selectedURL {
                Feature4DetailView(url: url, back: {
                    viewModel.closeWebView()
                })
            }
        }
    }
}

#Preview {
    NavigationStack {
        Feature4View(viewModel: Feature4VM())
    }
}
