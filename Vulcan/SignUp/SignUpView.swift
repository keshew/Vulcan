import SwiftUI

struct SignUpView: View {
    @StateObject var signUpModel = SignUpViewModel()
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isSign: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var isMain: Bool = false
    
    private let bgColor = Color(red: 1/255, green: 90/255, blue: 174/255)
    private let dangerRed = Color(red: 255/255, green: 63/255, blue: 58/255)
    
    var body: some View {
        ZStack {
            backgroundView()
            backImageView()
            mainVStack()
        }
        .fullScreenCover(isPresented: $isSign, content: { RegistationView() })
        .fullScreenCover(isPresented: $isMain, content: { MainView() })
        .alert(isPresented: $showAlert, content: alertContent)
    }
    
    @ViewBuilder
    private func backgroundView() -> some View {
        bgColor
            .ignoresSafeArea()
    }
    
    @ViewBuilder
    private func backImageView() -> some View {
        Image(.back)
            .resizable()
            .ignoresSafeArea()
    }
    
    @ViewBuilder
    private func mainVStack() -> some View {
        VStack(alignment: .leading) {
            header()
            Spacer()
            loginSection()
            Spacer()
            buttonsSection()
        }
        .padding(.vertical)
    }
    
    @ViewBuilder
    private func header() -> some View {
        HStack {
            Text("Log in")
                .ProBold(size: 34)
                .padding(.leading)
                .padding(.top)
            Spacer()
        }
    }
    
    @ViewBuilder
    private func loginSection() -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 15) {
                infoText()
                emailField()
                passwordField()
                signUpPrompt()
            }
            Spacer()
        }
        .padding(.leading)
    }
    
    @ViewBuilder
    private func infoText() -> some View {
        Text("Log in to continue organizing your habits in easiest way")
            .Pro(size: 20)
    }
    
    @ViewBuilder
    private func emailField() -> some View {
        CustomTextFiled(text: $email, placeholder: "Enter your email")
    }
    
    @ViewBuilder
    private func passwordField() -> some View {
        CustomSecureField(text: $password, placeholder: "Enter your password")
    }
    
    @ViewBuilder
    private func signUpPrompt() -> some View {
        HStack {
            Text("Have not an account?").Pro(size: 14)
            Button(action: { isSign = true }) {
                Text("Sign up")
                    .ProBold(size: 14, color: dangerRed)
            }
        }
    }
    
    @ViewBuilder
    private func buttonsSection() -> some View {
        HStack {
            Spacer()
            guestAndLoginButtons()
        }
    }
    
    @ViewBuilder
    private func guestAndLoginButtons() -> some View {
        HStack(spacing: 20) {
            guestButton()
            continueButton()
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.trailing)
    }
    
    @ViewBuilder
    private func guestButton() -> some View {
        Button(action: {
            UserDefaultsManager().enterAsGuest()
            isMain = true
        }) {
            buttonStyle(isFilled: false, text: "I'm a guest", width: 110)
        }
    }
    
    @ViewBuilder
    private func continueButton() -> some View {
        Button(action: {
            loginAction()
        }) {
            buttonStyle(isFilled: true, text: "Continue", width: 110)
        }
    }
    
    private func buttonStyle(isFilled: Bool, text: String, width: CGFloat) -> some View {
        let base = Rectangle()
            .frame(width: width, height: 40)
            .cornerRadius(20)
        
        return base
            .foregroundColor(isFilled ? dangerRed : .clear)
            .overlay(
                Group {
                    if isFilled {
                        Text(text).ProBold(size: 15)
                    } else {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white, lineWidth: 2)
                            .overlay(Text(text).ProBold(size: 15))
                    }
                }
            )
    }
    
    private func loginAction() {
        guard !email.isEmpty, !password.isEmpty else {
            alertMessage = "Please fill in all fields."
            showAlert = true
            return
        }
        
        NetworkManager.shared.login(email: email, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    isMain = true
                    UserDefaultsManager().saveLoginStatus(true)
                    UserDefaultsManager().saveName(user.user_id)
                case .failure(let error):
                    alertMessage = error.localizedDescription
                    showAlert = true
                }
            }
        }
    }
    
    private func alertContent() -> Alert {
        Alert(title: Text("Error"),
              message: Text(alertMessage),
              dismissButton: .default(Text("OK")))
    }
}

#Preview {
    SignUpView()
}
