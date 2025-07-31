import SwiftUI

struct RegistationView: View {
    @StateObject var registationModel = RegistationViewModel()
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLogin: Bool = false
    
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var isMain: Bool = false
    
    private let bgColor = Color(red: 1/255, green: 90/255, blue: 174/255)
    private let dangerRed = Color(red: 255/255, green: 63/255, blue: 58/255)
    
    var body: some View {
        ZStack {
            backgroundColor()
            backgroundImage()
            mainContent()
        }
        .fullScreenCover(isPresented: $isLogin, content: { SignUpView() })
        .fullScreenCover(isPresented: $isMain, content: { MainView() })
        .alert(isPresented: $showAlert, content: alertView)
    }
    
    // MARK: - Background views
    
    private func backgroundColor() -> some View {
        bgColor
            .ignoresSafeArea()
    }
    
    private func backgroundImage() -> some View {
        Image(.back)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .ignoresSafeArea()
    }
    
    // MARK: - Main content stack
    
    private func mainContent() -> some View {
        VStack(alignment: .leading) {
            header()
            Spacer()
            infoAndFieldsSection()
            Spacer()
            buttonsSection()
        }
        .padding(.vertical)
    }
    
    // MARK: - Header
    
    private func header() -> some View {
        HStack {
            Text("Registation")
                .ProBold(size: 34)
                .padding(.leading)
                .padding(.top)
            Spacer()
        }
    }
    
    // MARK: - Info and text fields
    
    private func infoAndFieldsSection() -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 15) {
                infoText()
                emailField()
                passwordField()
                loginPrompt()
            }
            Spacer()
        }
        .padding(.leading)
    }
    
    private func infoText() -> some View {
        Text("Sign in to continue organizing your habits in easiest way")
            .Pro(size: 20)
    }
    
    private func emailField() -> some View {
        CustomTextFiled(text: $email, placeholder: "Enter your email")
    }
    
    private func passwordField() -> some View {
        CustomSecureField(text: $password, placeholder: "Enter your password")
    }
    
    private func loginPrompt() -> some View {
        HStack {
            Text("Have an account?")
                .Pro(size: 14)
            Button(action: {
                isLogin = true
            }) {
                Text("Log in")
                    .ProBold(size: 14, color: dangerRed)
            }
        }
    }
    
    // MARK: - Buttons section
    
    private func buttonsSection() -> some View {
        HStack {
            Spacer()
            guestAndContinueButtons()
        }
    }
    
    private func guestAndContinueButtons() -> some View {
        HStack(spacing: 20) {
            guestButton()
            continueButton()
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.trailing)
    }
    
    private func guestButton() -> some View {
        Button(action: {
            UserDefaultsManager().enterAsGuest()
            isMain = true
        }) {
            guestButtonStyle()
        }
    }
    
    private func guestButtonStyle() -> some View {
        Rectangle()
            .fill(.clear)
            .frame(width: 110, height: 40)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white, lineWidth: 3)
                    .overlay(
                        Text("I'm a guest")
                            .ProBold(size: 15)
                    )
            )
            .cornerRadius(20)
    }
    
    private func continueButton() -> some View {
        Button(action: {
            continueButtonTapped()
        }) {
            continueButtonStyle()
        }
    }
    
    private func continueButtonStyle() -> some View {
        Rectangle()
            .fill(dangerRed)
            .frame(width: 110, height: 40)
            .overlay(
                Text("Continue")
                    .ProBold(size: 15)
            )
            .cornerRadius(20)
    }
    
    // MARK: - Actions
    
    private func continueButtonTapped() {
        guard !email.isEmpty, !password.isEmpty else {
            alertMessage = "Please fill in all fields."
            showAlert = true
            return
        }
        
        NetworkManager.shared.register(email: email, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    isMain = true
                    UserDefaultsManager().saveLoginStatus(true)
                    UserDefaultsManager().saveName(user)
                case .failure(let error):
                    alertMessage = error.localizedDescription
                    showAlert = true
                }
            }
        }
    }
    
    // MARK: - Alert
    
    private func alertView() -> Alert {
        Alert(
            title: Text("Error"),
            message: Text(alertMessage),
            dismissButton: .default(Text("OK"))
        )
    }
}

#Preview {
    RegistationView()
}


struct CustomTextFiled: View {
    @Binding var text: String
    @FocusState var isTextFocused: Bool
    var placeholder: String
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .fill(.black.opacity(0.15))
                .frame(height: 50)
                .cornerRadius(12)
                .padding(.trailing, 250)
//                .padding(.horizontal, 15)
            
            TextField("", text: $text, onEditingChanged: { isEditing in
                if !isEditing {
                    isTextFocused = false
                }
            })
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
//            .padding(.horizontal, 16)
            .frame(height: 47)
            .font(.custom("SFProDisplay-Regular", size: 15))
            .cornerRadius(9)
            .foregroundStyle(.white)
            .focused($isTextFocused)
            .padding(.horizontal, 15)
            
            if text.isEmpty && !isTextFocused {
                Text(placeholder)
                    .Pro(size: 16, color: Color(red: 141/255, green: 160/255, blue: 179/255))
                    .frame(height: 50)
                    .padding(.leading, 15)
                    .onTapGesture {
                        isTextFocused = true
                    }
            }
        }
    }
}

struct CustomSecureField: View {
    @Binding var text: String
    @FocusState var isTextFocused: Bool
    var placeholder: String
    
    @State private var isSecure: Bool = true
    
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .fill(.black.opacity(0.15))
                .frame(height: 50)
                .cornerRadius(12)
                .padding(.trailing, 250)
            
            HStack {
                if isSecure {
                    SecureField("", text: $text)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .font(.custom("SFProDisplay-Regular", size: 16))
                        .foregroundStyle(.white)
                        .focused($isTextFocused)
                } else {
                    TextField("", text: $text)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .font(.custom("SFProDisplay-Regular", size: 16))
                        .foregroundStyle(.white)
                        .focused($isTextFocused)
                }
            }
            .padding(.horizontal, 16)
            .frame(height: 50)
            .cornerRadius(9)
            
            if text.isEmpty && !isTextFocused {
                Text(placeholder)
                    .font(.custom("SFProDisplay-Regular", size: 16))
                    .foregroundColor(Color(red: 141/255, green: 160/255, blue: 179/255))
                    .frame(height: 50)
                    .padding(.leading, 15)
                    .onTapGesture {
                        isTextFocused = true
                    }
            }
        }
    }
}
