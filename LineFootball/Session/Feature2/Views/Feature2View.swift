import SwiftUI
import UIKit

struct Feature2View: View {
    
    @ObservedObject var viewModel: Feature2VM
    
    var body: some View {
        VStack {
            Text("Players".localized())
                .bold()
                .font(.largeTitle)
                .foregroundStyle(Color.palette(.white))
                .padding(.leading, 16)
                .frame(height: 80)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.palette(.darkGreenColor))
            
            if viewModel.records.isEmpty {
                VStack(spacing: 4) {
                    Text("No players yet")
                        .font(.body)
                        .foregroundStyle(Color.palette(.black900))
                    
                    Text("Tap + to add your team roster")
                        .font(.caption)
                        .fontWeight(.regular)
                        .foregroundStyle(Color.gray)
                }
                .padding(.top, UIScreen.main.bounds.height / 3)
            } else {
                contentView()
                    .padding(.top, 24)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.palette(.backColor))
        .overlay(alignment: .bottomTrailing, content: addMatchBtn)
        .onAppear { viewModel.refreshRecords() }
    }
    
    @ViewBuilder
    private func contentView() -> some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 8) {
                ForEach(viewModel.records) { item in
                    HStack {
                        PlayerAvatarView(imageFilename: item.imagePlayer)
                        
                        VStack(alignment: .leading) {
                            Text(item.position)
                                .font(.caption)
                                .fontWeight(.regular)
                                .foregroundStyle(Color.palette(.grayColor))
                            
                            Text("\(item.fisrtName) \(item.secondName)")
                                .foregroundStyle(Color.palette(.black900))
                        }
                        
                        Spacer()
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity)
                    .background(Color.palette(.white))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal, 16)
                }
            }
        }
    }
    
    @ViewBuilder
    private func addMatchBtn() -> some View {
        Button {
            viewModel.onDetailTapped()
        } label: {
            HStack {
                Text("+")
                    .font(.largeTitle)
                    .foregroundStyle(Color.palette(.white))
            }
            .padding(.vertical)
            .frame(width: 56, height: 56)
            .background(Color.palette(.greenColor))
            .clipShape(RoundedRectangle(cornerRadius: 100))
            .padding(.trailing, 16)
        }
        .padding(.bottom, 50)
        .buttonStyle(.plain)
    }
}

struct PlayerAvatarView: View {
    let imageFilename: String

    var body: some View {
        Group {
            if !imageFilename.isEmpty, let uiImage = PlayerPhotoStorage.loadImage(filename: imageFilename) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                Image("player")
                    .resizable()
                    .scaledToFit()
            }
        }
        .frame(width: 40, height: 40)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    NavigationStack {
        Feature2View(viewModel: Feature2VM(service: .init()))
    }
}
