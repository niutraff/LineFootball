import SwiftUI

struct Feature3View: View {

    @ObservedObject var viewModel: Feature3VM

    var body: some View {
        VStack {
            Text("Matches".localized())
                .bold()
                .font(.largeTitle)
                .foregroundStyle(Color.palette(.white))
                .padding(.leading, 16)
                .frame(height: 80)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.palette(.darkGreenColor))
            
            if viewModel.records.isEmpty {
                VStack(spacing: 4) {
                    Text("No games yet")
                        .font(.body)
                        .foregroundStyle(Color.palette(.black900))
                    
                    Text("Tap + to add your first game")
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
                        Text(item.homeTeam)
                            .font(.body)
                            .foregroundStyle(Color.palette(.black900))
                        
                        Spacer()
                        
                        VStack {
                            Text(item.time.timeToString())
                                .font(.body)
                                .foregroundStyle(Color.gray)
                            
                            Text(item.date.dateToString())
                                .font(.body)
                                .foregroundStyle(Color.palette(.black900))
                        }
                        
                        Spacer()
                        
                        Text(item.awayTeam)
                            .font(.body)
                            .foregroundStyle(Color.palette(.black900))
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

#Preview {
    NavigationStack {
        Feature3View(viewModel: Feature3VM(service: Feature3Service()))
    }
}
