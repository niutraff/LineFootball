import SwiftUI

struct Feature3DetailView: View {

    @ObservedObject var viewModel: Feature3DetailVM
    
    @FocusState
    private var isInputActive: Bool

    var body: some View {
        VStack {
            VStack {
                Text("Teams & Date")
                    .foregroundStyle(Color.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 16)
                
                contentView()
            }
            .padding(.top, 25)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.palette(.backColor))
        .navigationView(title: "Add Match", showsBackButton: true, onBackButtonTap: viewModel.onBackTapped)
        .overlay(alignment: .bottom, content: buttonView)
        .onTapGesture {
            isInputActive = false
        }
    }
    
    @ViewBuilder
    private func contentView() -> some View {
        VStack {
            TextField("", text: Binding(
                get: { viewModel.matchInfo.homeTeam },
                set: { var c = viewModel.matchInfo; c.homeTeam = $0; viewModel.matchInfo = c }
            ))
            .foregroundStyle(Color.palette(.textPrimary))
            .frame(height: 44)
            .frame(maxWidth: .infinity)
            .keyboardType(.default)
            .focused($isInputActive)
            .placeholder(
                showPlaceHolder: viewModel.matchInfo.homeTeam.isEmpty,
                placeholder: "Home team"
            )
            .padding(.leading, 16)
            
            Divider().padding(.leading)
            
            TextField("", text: Binding(
                get: { viewModel.matchInfo.awayTeam },
                set: { var c = viewModel.matchInfo; c.awayTeam = $0; viewModel.matchInfo = c }
            ))
            .foregroundStyle(Color.palette(.textPrimary))
            .frame(height: 44)
            .frame(maxWidth: .infinity)
            .keyboardType(.default)
            .focused($isInputActive)
            .placeholder(
                showPlaceHolder: viewModel.matchInfo.awayTeam.isEmpty,
                placeholder: "Away team"
            )
            .padding(.leading, 16)
            
            Divider().padding(.leading)
            
            HStack {
                Text("Date")
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.palette(.black900))
                
                Spacer()
                
                ZStack(alignment: .trailing) {
                    DatePicker(
                        "",
                        selection: Binding(
                            get: { viewModel.matchInfo.date },
                            set: { var c = viewModel.matchInfo; c.date = $0; viewModel.matchInfo = c }
                        ),
                        displayedComponents: .date
                    )
                    .datePickerStyle(.compact)
                    .labelsHidden()
                    .tint(Color.palette(.greenColor))
                    .colorScheme(.light)
                    .opacity(0.015)
                    .contentShape(Rectangle())
                    
                    Text(viewModel.matchInfo.date, style: .date)
                        .foregroundStyle(Color.palette(.black900))
                        .padding(.vertical, 10)
                        .padding(.horizontal, 16)
                        .background(Color.palette(.borderColor))
                        .clipShape(RoundedRectangle(cornerRadius: 60))
                        .allowsHitTesting(false)
                }
            }
            .frame(height: 44)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
            
            Divider().padding(.leading)
            
            HStack {
                Text("Time")
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.palette(.black900))
                
                Spacer()
                
                ZStack(alignment: .trailing) {
                    DatePicker(
                        "",
                        selection: Binding(
                            get: { viewModel.matchInfo.time },
                            set: { var c = viewModel.matchInfo; c.time = $0; viewModel.matchInfo = c }
                        ),
                        displayedComponents: .hourAndMinute
                    )
                    .datePickerStyle(.compact)
                    .labelsHidden()
                    .tint(Color.palette(.greenColor))
                    .colorScheme(.light)
                    .opacity(0.015)
                    .contentShape(Rectangle())
                    
                    Text(viewModel.matchInfo.time, style: .time)
                        .foregroundStyle(Color.palette(.black900))
                        .padding(.vertical, 10)
                        .padding(.horizontal, 16)
                        .background(Color.palette(.borderColor))
                        .clipShape(RoundedRectangle(cornerRadius: 60))
                        .allowsHitTesting(false)
                }
            }
            .frame(height: 44)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
            
            Divider().padding(.leading)
            
            TextField("", text: Binding(
                get: { viewModel.matchInfo.location },
                set: { var c = viewModel.matchInfo; c.location = $0; viewModel.matchInfo = c }
            ))
            .foregroundStyle(Color.palette(.textPrimary))
            .frame(height: 44)
            .frame(maxWidth: .infinity)
            .keyboardType(.default)
            .focused($isInputActive)
            .placeholder(
                showPlaceHolder: viewModel.matchInfo.location.isEmpty,
                placeholder: "Location"
            )
            .padding(.leading, 16)
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
                viewModel.saveMatch()
            } label: {
                HStack {
                    Text("Save match")
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
            .disabled(viewModel.matchInfo.isValid)
        }
    }
}

#Preview {
    NavigationStack {
        Feature3DetailView(viewModel: Feature3DetailVM(service: .init()))
    }
}
