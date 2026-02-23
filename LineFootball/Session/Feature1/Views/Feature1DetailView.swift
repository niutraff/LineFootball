import SwiftUI

struct Feature1DetailView: View {

    @ObservedObject var viewModel: Feature1DetailVM
    
    @FocusState
    private var isInputActive: Bool

    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    teamDateView()
                    scoreView()
                    cardsView()
                }
                .padding(.top)
                .padding(.bottom, 100)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.palette(.backColor))
        .navigationView(title: "Edit Match", showsBackButton: true, onBackButtonTap: viewModel.onBackTapped)
        .overlay(alignment: .bottom, content: buttonView)
        .onTapGesture {
            isInputActive = false
        }
    }
    
    @ViewBuilder
    private func teamDateView() -> some View {
        VStack {
            Text("Teams & Date")
                .foregroundStyle(Color.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
            
            VStack {
                TextField("", text: Binding(
                    get: { viewModel.comandInfo.homeTeam },
                    set: { var c = viewModel.comandInfo; c.homeTeam = $0; viewModel.comandInfo = c }
                ))
                .foregroundStyle(Color.palette(.textPrimary))
                .frame(height: 44)
                .frame(maxWidth: .infinity)
                .keyboardType(.default)
                .focused($isInputActive)
                .placeholder(
                    showPlaceHolder: viewModel.comandInfo.homeTeam.isEmpty,
                    placeholder: "Home team"
                )
                .padding(.leading, 16)
                
                Divider().padding(.leading)
                
                TextField("", text: Binding(
                    get: { viewModel.comandInfo.awayTeam },
                    set: { var c = viewModel.comandInfo; c.awayTeam = $0; viewModel.comandInfo = c }
                ))
                .foregroundStyle(Color.palette(.textPrimary))
                .frame(height: 44)
                .frame(maxWidth: .infinity)
                .keyboardType(.default)
                .focused($isInputActive)
                .placeholder(
                    showPlaceHolder: viewModel.comandInfo.awayTeam.isEmpty,
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
                                get: { viewModel.comandInfo.date },
                                set: { var c = viewModel.comandInfo; c.date = $0; viewModel.comandInfo = c }
                            ),
                            displayedComponents: .date
                        )
                        .datePickerStyle(.compact)
                        .labelsHidden()
                        .tint(Color.palette(.greenColor))
                        .colorScheme(.light)
                        .opacity(0.015)
                        .contentShape(Rectangle())
                        
                        Text(viewModel.comandInfo.date, style: .date)
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
                                get: { viewModel.comandInfo.time },
                                set: { var c = viewModel.comandInfo; c.time = $0; viewModel.comandInfo = c }
                            ),
                            displayedComponents: .hourAndMinute
                        )
                        .datePickerStyle(.compact)
                        .labelsHidden()
                        .tint(Color.palette(.greenColor))
                        .colorScheme(.light)
                        .opacity(0.015)
                        .contentShape(Rectangle())
                        
                        Text(viewModel.comandInfo.time, style: .time)
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
    }
    
    // MARK: - Score section
    @ViewBuilder
    private func scoreView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Score")
                .foregroundStyle(Color.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)

            VStack(alignment: .leading, spacing: 0) {
                // We were the home team
                HStack {
                    Text("We were the home team")
                        .font(.body)
                        .foregroundStyle(Color.palette(.black900))
                    Spacer()
                    Toggle("", isOn: Binding(
                        get: { viewModel.comandInfo.weWereHomeTeam },
                        set: { viewModel.setWeWereHomeTeam($0) }
                    ))
                    .labelsHidden()
                    .tint(Color.palette(.greenColor))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)

                Divider().padding(.leading, 16)

                stepperRow(label: "Goals (us)", value: viewModel.comandInfo.goalUs, showPlusPrefix: true, onMinus: viewModel.decrementGoalUs, onPlus: viewModel.incrementGoalUs)
                Divider().padding(.leading, 16)
                stepperRow(label: "Goals (them)", value: viewModel.comandInfo.goalThem, showPlusPrefix: false, onMinus: viewModel.decrementGoalThem, onPlus: viewModel.incrementGoalThem)
                Divider().padding(.leading, 16)
                stepperRow(label: "Saves", value: viewModel.comandInfo.saves, showPlusPrefix: false, onMinus: viewModel.decrementSaves, onPlus: viewModel.incrementSaves)
                Divider().padding(.leading, 16)
                stepperRow(label: "Assits", value: viewModel.comandInfo.assits, showPlusPrefix: false, onMinus: viewModel.decrementAssits, onPlus: viewModel.incrementAssits)
                Divider().padding(.leading, 16)

                VStack(alignment: .leading, spacing: 6) {
                    Text("Scoreline")
                        .font(.subheadline)
                        .foregroundStyle(Color.palette(.grayColor))
                    
                    Text(viewModel.scorelineText)
                        .bold()
                        .foregroundStyle(Color.palette(.black900))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.palette(.white))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.palette(.borderColor), lineWidth: 1))
            .padding(.horizontal, 16)
        }
    }

    // MARK: - Cards section
    @ViewBuilder
    private func cardsView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Cards")
                .foregroundStyle(Color.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)

            VStack(alignment: .leading, spacing: 0) {
                stepperRow(label: "Yellow cards", value: viewModel.comandInfo.yellowCard, showPlusPrefix: false, onMinus: viewModel.decrementYellowCard, onPlus: viewModel.incrementYellowCard)
                Divider().padding(.leading, 16)
                stepperRow(label: "Red cards", value: viewModel.comandInfo.redCard, showPlusPrefix: false, onMinus: viewModel.decrementRedCard, onPlus: viewModel.incrementRedCard)
                Divider().padding(.leading, 16)
                HStack {
                    Text("Final cards")
                        .bold()
                        .foregroundStyle(Color.palette(.black900))
                    Spacer()
                    Text(viewModel.comandInfo.totalCards > 0 ? "\(viewModel.comandInfo.totalCards)" : "")
                        .bold()
                        .foregroundStyle(Color.palette(.black900))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.palette(.white))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.palette(.borderColor), lineWidth: 1))
            .padding(.horizontal, 16)
        }
    }

    @ViewBuilder
    private func stepperRow(label: String, value: Int, showPlusPrefix: Bool = false, onMinus: @escaping () -> Void, onPlus: @escaping () -> Void) -> some View {
        HStack {
            Text(label)
                .font(.body)
                .foregroundStyle(Color.palette(.black900))
            Spacer()
            Text(showPlusPrefix ? "+\(value)" : "\(value)")
                .font(.body)
                .foregroundStyle(Color.palette(.black900))
                .frame(minWidth: 24, alignment: .trailing)
            HStack(spacing: 16) {
                Button(action: onMinus) {
                    Image(systemName: "minus")
                        .bold()
                        .foregroundStyle(Color.palette(.black900))
                }
                .buttonStyle(.plain)
                Button(action: onPlus) {
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
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
    
    @ViewBuilder
    private func buttonView() -> some View {
        if isInputActive == false {
            Button {
                viewModel.saveComandInfo()
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
            .disabled(viewModel.comandInfo.isValid)
        }
    }
}

#Preview {
    NavigationStack {
        Feature1DetailView(viewModel: Feature1DetailVM(service: .init()))
    }
}
