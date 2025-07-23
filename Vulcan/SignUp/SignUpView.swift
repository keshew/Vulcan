import SwiftUI

struct SignUpView: View {
    @StateObject var signUpModel =  SignUpViewModel()
    @State var email = ""
    @State var password = ""
    @State var isSign = false
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isMain = false
    
    var body: some View {
        ZStack {
            Color(red: 1/255, green: 90/255, blue: 174/255).ignoresSafeArea()
            
            Image(.back)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                HStack {
                    Text("Log in")
                        .ProBold(size: 34)
                        .padding(.leading)
                        .padding(.top)
                    
                    Spacer()
                }
                
                Spacer()
                
                HStack {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Log in to continue organizing your habits in easiest way")
                            .Pro(size: 20)
                        
                        CustomTextFiled(text: $email, placeholder: "Enter your email")
                        
                        CustomSecureField(text: $password, placeholder: "Enter your password")
                        
                        HStack {
                            Text("Have not an account?")
                                .Pro(size: 14)
                            
                            Button(action: {
                                isSign = true
                            }) {
                                Text("Sign up")
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
                            
                            NetworkManager.shared.login(email: email, password: password) { result in
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
        .fullScreenCover(isPresented: $isSign) {
            RegistationView()
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
    SignUpView()
}

