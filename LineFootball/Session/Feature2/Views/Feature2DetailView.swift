import SwiftUI
import UIKit

struct Feature2DetailView: View {

    @ObservedObject var viewModel: Feature2DetailVM

    @FocusState
    private var isInputActive: Bool

    @State private var showImagePicker = false
    @State private var pickedImage: UIImage?

    var body: some View {
        VStack(spacing: 0) {
            photoSection()
                .padding(.top, 24)

            VStack {
                Text("Details")
                    .foregroundStyle(Color.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 16)

                contentView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.palette(.backColor))
        .navigationView(title: "Add Player", showsBackButton: true, onBackButtonTap: viewModel.onBackTapped)
        .overlay(alignment: .bottom, content: buttonView)
        .onTapGesture {
            isInputActive = false
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $pickedImage)
        }
        .onChange(of: pickedImage) { newValue in
            viewModel.setSelectedImage(newValue)
        }
    }

    @ViewBuilder
    private func photoSection() -> some View {
        let squareSize: CGFloat = 170
        let cornerRadius: CGFloat = 24

        VStack(spacing: 0) {
            ZStack {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.palette(.white))
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(Color.palette(.borderColor), lineWidth: 1)
                    )
                    .frame(width: squareSize, height: squareSize)

                if let image = viewModel.selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: squareSize, height: squareSize)
                        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                } else {
                    Image("addUser")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                }
            }

            Button {
                showImagePicker = true
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "photo.on.rectangle.angled")
                       
                    Text("Choose photo")
                        .font(.subheadline)
                }
                .foregroundStyle(Color.palette(.black900))
                .padding(.vertical, 6)
                .padding(.horizontal, 8)
                .background(Color.palette(.borderColor))
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .buttonStyle(.plain)
            .offset(y: -50)
        }
        .frame(width: squareSize)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 16)
    }
    
    @ViewBuilder
    private func contentView() -> some View {
        VStack {
            TextField("", text: Binding(
                get: { viewModel.playerInfo.fisrtName },
                set: { var c = viewModel.playerInfo; c.fisrtName = $0; viewModel.playerInfo = c }
            ))
            .foregroundStyle(Color.palette(.black900))
            .frame(height: 44)
            .frame(maxWidth: .infinity)
            .keyboardType(.default)
            .focused($isInputActive)
            .placeholder(
                showPlaceHolder: viewModel.playerInfo.fisrtName.isEmpty,
                placeholder: "First Name"
            )
            .padding(.leading, 16)
            
            Divider().padding(.leading)
            
            TextField("", text: Binding(
                get: { viewModel.playerInfo.secondName },
                set: { var c = viewModel.playerInfo; c.secondName = $0; viewModel.playerInfo = c }
            ))
            .foregroundStyle(Color.palette(.black900))
            .frame(height: 44)
            .frame(maxWidth: .infinity)
            .keyboardType(.default)
            .focused($isInputActive)
            .placeholder(
                showPlaceHolder: viewModel.playerInfo.secondName.isEmpty,
                placeholder: "Second Name"
            )
            .padding(.leading, 16)
            
            Divider().padding(.leading)
            
            TextField("", text: Binding(
                get: { viewModel.playerInfo.position },
                set: { var c = viewModel.playerInfo; c.position = $0; viewModel.playerInfo = c }
            ))
            .foregroundStyle(Color.palette(.black900))
            .frame(height: 44)
            .frame(maxWidth: .infinity)
            .keyboardType(.default)
            .focused($isInputActive)
            .placeholder(
                showPlaceHolder: viewModel.playerInfo.position.isEmpty,
                placeholder: "Position (optional)"
            )
            .padding(.leading, 16)
            
            Divider().padding(.leading)
            
            HStack {
                Text("Age")
                    .foregroundStyle(Color.palette(.black900))
                
                Spacer()
                
                Text("\(viewModel.playerInfo.age)")
                
                HStack(spacing: 20) {
                    Button {
                        viewModel.decrementAge()
                    } label: {
                        Image(systemName: "minus")
                            .bold()
                            .foregroundStyle(Color.palette(.black900))
                    }

                    Button {
                        viewModel.incrementAge()
                    } label: {
                        Image(systemName: "plus")
                            .bold()
                            .foregroundStyle(Color.palette(.black900))
                    }
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 16)
                .background(Color.palette(.borderColor))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(.horizontal, 16)
            .frame(height: 44)
            .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity)
        .background(Color.palette(.white))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(content: {
            RoundedRectangle(cornerRadius: 16)
                .stroke(lineWidth: 1).fill(Color.palette(.borderColor))
        })
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    private func buttonView() -> some View {
        if isInputActive == false {
            Button {
                viewModel.savePlayer()
            } label: {
                HStack {
                    Text("Save player")
                        .foregroundStyle(Color.palette(.white))
                }
                .padding(.vertical)
                .frame(maxWidth: .infinity)
                .background(Color.palette(.greenColor))
                .clipShape(RoundedRectangle(cornerRadius: 60))
                .padding(.horizontal, 16)
            }
            .padding(.bottom, 30)
            .buttonStyle(.plain)
            .disabled(viewModel.playerInfo.isValid)
        }
    }
}

#Preview {
    NavigationStack {
        Feature2DetailView(viewModel: Feature2DetailVM(service: .init()))
    }
}
