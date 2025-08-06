import SwiftUI

struct StatisticView: View {
    @StateObject var statisticModel = StatisticViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var isDeleting = false
    @State private var showDeleteConfirmation: Bool = false
    @State var isSign: Bool = false
    
    private let userId: String? = UserDefaultsManager().getName()
    private let dangerRed = Color(red: 255/255, green: 63/255, blue: 58/255)
    private let backgroundBlue = Color(red: 1/255, green: 90/255, blue: 174/255)
    
    var body: some View {
        ZStack {
            backgroundView()
            backImage()
            contentStack()
        }
        .fullScreenCover(isPresented: $isSign, content: { SignUpView() })
    }
    
    @ViewBuilder
    private func backgroundView() -> some View {
        backgroundBlue.ignoresSafeArea()
    }
    
    @ViewBuilder
    private func backImage() -> some View {
        Image(.back)
            .resizable()
            .ignoresSafeArea()
    }
    
    @ViewBuilder
    private func contentStack() -> some View {
        VStack(alignment: .leading) {
            header()
            Spacer()
            if !UserDefaultsManager().isGuest() {
                statisticsSection()
            }
            Spacer()
            buttonsSection()
        }
        .padding(.vertical)
    }
    
    @ViewBuilder
    private func header() -> some View {
        HStack {
            Text("Statistics")
                .ProBold(size: 34)
                .padding(.leading)
                .padding(.top)
            Spacer()
        }
    }
    
    @ViewBuilder
    private func statisticsSection() -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 15) {
                statisticRow(title: "Your record in the game:", value: "\(statisticModel.yourRecord) score")
                statisticDivider()
                statisticRow(title: "World record in the game:", value: "6312 score")
                statisticDivider()
                statisticRow(title: "Logged in to the app:", value: "\(statisticModel.consecutiveDays) days in a row")
                statisticDivider()
                statisticRow(title: "Viewed volcanoes:", value: "\(statisticModel.viewedVolcanoesCount)")
            }
            Spacer()
        }
        .padding(.leading)
    }
    
    @ViewBuilder
    private func statisticRow(title: String, value: String) -> some View {
        HStack {
            Text(title).Pro(size: 20)
            Text(value).ProBold(size: 20)
        }
    }
    
    @ViewBuilder
    private func statisticDivider() -> some View {
        Rectangle()
            .fill(Color.white)
            .frame(height: 2)
            .padding(.trailing, 400)
    }
    
    @ViewBuilder
    private func buttonsSection() -> some View {
        if !UserDefaultsManager().isGuest() {
            loggedInButtons()
        } else {
            guestButtons()
        }
    }
    
    @ViewBuilder
    private func loggedInButtons() -> some View {
        HStack {
            deleteAccountButton()
                .padding(.trailing)
                .confirmationDialog(
                    "Are you sure you want to delete your account?",
                    isPresented: $showDeleteConfirmation,
                    titleVisibility: .visible
                ) {
                    Button("OK", role: .destructive, action: deleteAccount)
                    Button("Cancel", role: .cancel, action: {})
                } message: {
                    Text("This action cannot be undone.")
                }

            logOutButton()
                .padding(.trailing)
            
            Spacer()
            
            backButton()
                .padding(.trailing)
        }
        .padding(.leading)
    }
    
    @ViewBuilder
    private func guestButtons() -> some View {
        HStack {
            createAccountButton()
                .padding(.trailing)
            logInButton()
                .padding(.trailing)
            
            Spacer()
            
            backButton()
                .padding(.trailing)
        }
    }
    
    @ViewBuilder
    private func deleteAccountButton() -> some View {
        Button {
            showDeleteConfirmation = true
        } label: {
            rectangleButton(text: "Delete Account", width: 140)
        }
    }
    
    @ViewBuilder
    private func logOutButton() -> some View {
        Button {
            isSign = true
            UserDefaultsManager().saveLoginStatus(false)
            UserDefaultsManager().resetAllData()
        } label: {
            rectangleButton(text: "Log out", width: 90)
        }
    }
    
    @ViewBuilder
    private func backButton() -> some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            rectangleButton(text: "Back", width: 80)
        }
    }
    
    @ViewBuilder
    private func createAccountButton() -> some View {
        Button {
            isSign = true
            UserDefaultsManager().quitQuest()
        } label: {
            rectangleButton(text: "Create account", width: 140)
        }
    }
    
    @ViewBuilder
    private func logInButton() -> some View {
        Button {
            isSign = true
            UserDefaultsManager().quitQuest()
        } label: {
            rectangleButton(text: "Log in", width: 90)
        }
    }
    
    private func rectangleButton(text: String, width: CGFloat) -> some View {
        Rectangle()
            .fill(dangerRed)
            .frame(width: width, height: 40)
            .cornerRadius(20)
            .overlay(
                Text(text).ProBold(size: 15)
            )
    }
    
    private func deleteAccount() {
        guard !isDeleting else { return }
        isDeleting = true
        
        NetworkManager.shared.deleteAccount(userId: userId ?? "") { result in
            DispatchQueue.main.async {
                isDeleting = false
                switch result {
                case .success(_):
                    isSign = true
                    UserDefaultsManager().saveLoginStatus(false)
                    UserDefaultsManager().resetAllData()
                case .failure(let error):
                    alertMessage = error.localizedDescription
                    showAlert = true
                }
            }
        }
    }
}


#Preview {
    StatisticView()
}

