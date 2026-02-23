import SwiftUI
import UIKit

struct Feature1View: View {

    @ObservedObject var viewModel: Feature1VM

    @State private var showImagePicker = false
    @State private var pickedImage: UIImage?

    var body: some View {
        VStack(spacing: 0) {
            Text("Home".localized())
                .bold()
                .font(.largeTitle)
                .foregroundStyle(Color.palette(.white))
                .padding(.leading, 16)
                .frame(height: 80)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.palette(.darkGreenColor))

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    photoSection()
                    seasonGoalSection()
                    statsGrid()
                    
                    if !viewModel.records.isEmpty {
                        historyView()
                    }
                }
                .padding(.top, 24)
                .padding(.bottom, 80)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.palette(.backColor))
        .overlay(alignment: .bottomTrailing, content: addBtn)
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $pickedImage)
        }
        .onChange(of: pickedImage) { newValue in
            if let img = newValue {
                viewModel.setHomePhoto(img)
            }
        }
    }
    
    @ViewBuilder
    private func historyView() -> some View {
        VStack(spacing: 8) {
            Text("History")
                .padding(.horizontal)
                .foregroundStyle(Color.palette(.grayColor))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ForEach(viewModel.records) { item in
                HStack {
                    Image(.history)
                    
                    VStack(alignment: .leading) {
                        Text(item.date.dateToString())
                            .font(.caption)
                            .fontWeight(.regular)
                            .foregroundStyle(Color.palette(.grayColor))
                        
                        Text("\(item.homeTeam) \(item.goalUs) - \(item.goalThem) \(item.awayTeam)")
                            .foregroundStyle(Color.palette(.black900))
                    }
                    
                    Spacer()
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity)
                .background(Color.palette(.white))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
        .padding(.top, 16)
        .padding(.horizontal, 16)
    }

    @ViewBuilder
    private func photoSection() -> some View {
        let height: CGFloat = 190
        let cornerRadius: CGFloat = 16

        ZStack(alignment: .bottomTrailing) {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(Color.palette(.white))
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(Color.palette(.borderColor), lineWidth: 1)
                )
                .frame(height: height)
                .frame(maxWidth: .infinity)

            if let image = viewModel.homePhoto {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: height)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            }

            Button {
                showImagePicker = true
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "camera")
                        .font(.system(size: 14))
                    Text("Choose photo")
                        .font(.subheadline)
                }
                .foregroundStyle(Color.palette(.black900))
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(Color.palette(.borderColor))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)
            .padding(12)
        }
        .padding(.horizontal, 16)
    }

    // MARK: - Season Goal Target
    @ViewBuilder
    private func seasonGoalSection() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Season Goal Target")
                    .font(.headline)
                    .foregroundStyle(Color.palette(.black900))
                Spacer()
                Text("\(viewModel.allResult.scores)/\(viewModel.allResult.seasonGoalTarget)")
                    .font(.subheadline)
                    .foregroundStyle(Color.palette(.grayColor))
            }
            .frame(height: 30)
            
            Divider()
            
            HStack {
                Text("Target \(viewModel.allResult.seasonGoalTarget) goals")
                    .font(.subheadline)
                    .foregroundStyle(Color.palette(.grayColor))
                Spacer()
                HStack(spacing: 16) {
                    Button {
                        viewModel.decrementSeasonTarget()
                    } label: {
                        Image(systemName: "minus")
                            .bold()
                            .foregroundStyle(Color.palette(.black900))
                    }
                    .buttonStyle(.plain)
                    Button {
                        viewModel.incrementSeasonTarget()
                    } label: {
                        Image(systemName: "plus")
                            .bold()
                            .foregroundStyle(Color.palette(.black900))
                    }
                    .buttonStyle(.plain)
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 16)
                .background(Color.palette(.borderColor))
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .frame(height: 30)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.palette(.white))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.palette(.borderColor), lineWidth: 1)
        )
        .padding(.horizontal, 16)
    }

    // MARK: - Statistics grid 2x2
    @ViewBuilder
    private func statsGrid() -> some View {
        let columns = [
            GridItem(.flexible(), spacing: 12),
            GridItem(.flexible(), spacing: 12)
        ]
        LazyVGrid(columns: columns, spacing: 12) {
            statCard(icon: "games", label: "Games", value: viewModel.allResult.games)
            statCard(icon: "goals", label: "Goals", value: viewModel.allResult.scores)
            statCard(icon: "assits", label: "Assists", value: viewModel.allResult.assets)
            statCard(icon: "saves", label: "Saves", value: viewModel.allResult.saves)
        }
        .padding(.horizontal, 16)
    }

    @ViewBuilder
    private func statCard(icon: String, label: String, value: Int) -> some View {
        HStack(spacing: 8) {
            Image(icon)
    
            VStack(alignment: .leading) {
                Text(label)
                    .font(.caption)
                    .foregroundStyle(Color.palette(.grayColor))
                
                Text("\(value)")
                    .font(.body)
                    .fontWeight(.regular)
                    .foregroundStyle(Color.palette(.black900))
            }
            Spacer()
        }
        .padding(.leading, 16)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(Color.palette(.white))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.palette(.borderColor), lineWidth: 1)
        )
    }

    @ViewBuilder
    private func addBtn() -> some View {
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

#Preview {
    NavigationStack {
        Feature1View(viewModel: Feature1VM(service: Feature1Service()))
    }
}
