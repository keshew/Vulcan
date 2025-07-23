import SwiftUI

struct RegistationView: View {
    @StateObject var registationModel = RegistationViewModel()
    @State var email = ""
    @State var password = ""
    @State var isLogin = false
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State var isMain = false
    
    var body: some View {
        ZStack {
            Color(red: 1/255, green: 90/255, blue: 174/255).ignoresSafeArea()
            
            Image(.back)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                HStack {
                    Text("Registation")
                        .ProBold(size: 34)
                        .padding(.leading)
                        .padding(.top)
                    
                    Spacer()
                }
                
                Spacer()
                
                HStack {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Sign in to continue organizing your habits in easiest way")
                            .Pro(size: 20)
                        
                        CustomTextFiled(text: $email, placeholder: "Enter your email")
                        
                        CustomSecureField(text: $password, placeholder: "Enter your password")
                        
                        HStack {
                            Text("Have an account?")
                                .Pro(size: 14)
                            
                            Button(action: {
                                isLogin = true
                            }) {
                                Text("Log in")
                                    .ProBold(size: 14, color: Color(red: 255/255, green: 63/255, blue: 58/255))
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding(.leading)
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    HStack(spacing: 20) {
                        Button(action: {
                            UserDefaultsManager().enterAsGuest()
                            isMain = true
                        }) {
                            Rectangle()
                                .fill(.clear)
                                .frame(width: 110, height: 40)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(.white, lineWidth: 3)
                                    
                                    Text("I'm a guest")
                                        .ProBold(size: 15)
                                }
                                .cornerRadius(20)
                        }
                        
                        Button(action: {
                            if email.isEmpty || password.isEmpty {
                                alertMessage = "Please fill in all fields."
                                showAlert = true
                                return
                            }
                            
                            NetworkManager.shared.register(email: email, password: password) { result in
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
                        }) {
                            Rectangle()
                                .fill(Color(red: 255/255, green: 63/255, blue: 58/255))
                                .frame(width: 110, height: 40)
                                .overlay {
                                    Text("Continue")
                                        .ProBold(size: 15)
                                }
                                .cornerRadius(20)
                        }
                    }
                }
            }
            .padding(.vertical)
        }
        .fullScreenCover(isPresented: $isLogin) {
            SignUpView()
        }
        .fullScreenCover(isPresented: $isMain) {
            MainView()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"),
                  message: Text(alertMessage),
                  dismissButton: .default(Text("OK")))
        }
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
