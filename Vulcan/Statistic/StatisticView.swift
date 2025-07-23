import SwiftUI

struct StatisticView: View {
    @StateObject var statisticModel =  StatisticViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isDeleting = false
    let userId = UserDefaultsManager().getName()
    @State var isSign = false
    
    var body: some View {
        ZStack {
            Color(red: 1/255, green: 90/255, blue: 174/255).ignoresSafeArea()
            
            Image(.back)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                HStack {
                    Text("Statistics")
                        .ProBold(size: 34)
                        .padding(.leading)
                        .padding(.top)
                    
                    Spacer()
                }
                
                Spacer()
                
                if !UserDefaultsManager().isGuest() {
                    HStack {
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("Your record in the game:")
                                    .Pro(size: 20)
                                
                                Text("\(statisticModel.yourRecord) score")
                                    .ProBold(size: 20)
                            }
                            
                            Rectangle()
                                .fill(.white)
                                .frame(height: 2)
                                .padding(.trailing, 400)
                            
                            HStack {
                                Text("World record in the game:")
                                    .Pro(size: 20)
                                
                                Text("6312 score")
                                    .ProBold(size: 20)
                            }
                            
                            Rectangle()
                                .fill(.white)
                                .frame(height: 2)
                                .padding(.trailing, 400)
                            
                            HStack {
                                Text("Logged in to the app:")
                                    .Pro(size: 20)
                                
                                Text("\(statisticModel.consecutiveDays) days in a row")
                                    .ProBold(size: 20)
                            }
                            
                            Rectangle()
                                .fill(.white)
                                .frame(height: 2)
                                .padding(.trailing, 400)
                            
                            HStack {
                                Text("Viewed volcanoes:")
                                    .Pro(size: 20)
                                
                                Text("\(statisticModel.viewedVolcanoesCount)")
                                    .ProBold(size: 20)
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(.leading)
                }
                
                Spacer()
                
                if !UserDefaultsManager().isGuest() {
                HStack {
                    Button(action: {
                        guard !isDeleting else { return }
                        isDeleting = true
                        
                        NetworkManager.shared.deleteAccount(userId: userId ?? "") { result in
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
                    }) {
                        Rectangle()
                            .fill(Color(red: 255/255, green: 63/255, blue: 58/255))
                            .frame(width: 140, height: 40)
                            .overlay {
                                Text("Delete Account")
                                    .ProBold(size: 15)
                            }
                            .cornerRadius(20)
                    }
                    .padding(.trailing)
                    
                    Button(action: {
                        isSign = true
                        UserDefaultsManager().saveLoginStatus(false)
                        UserDefaultsManager().resetAllData()
                    }) {
                        Rectangle()
                            .fill(Color(red: 255/255, green: 63/255, blue: 58/255))
                            .frame(width: 90, height: 40)
                            .overlay {
                                Text("Log out")
                                    .ProBold(size: 15)
                            }
                            .cornerRadius(20)
                    }
                    .padding(.trailing)
                    
                    Spacer()
                    
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Rectangle()
                            .fill(Color(red: 255/255, green: 63/255, blue: 58/255))
                            .frame(width: 80, height: 40)
                            .overlay {
                                Text("Back")
                                    .ProBold(size: 15)
                            }
                            .cornerRadius(20)
                    }
                    .padding(.trailing)
                }
                } else {
                    HStack {
                        Button(action: {
                            isSign = true
                            UserDefaultsManager().quitQuest()
                        }) {
                            Rectangle()
                                .fill(Color(red: 255/255, green: 63/255, blue: 58/255))
                                .frame(width: 140, height: 40)
                                .overlay {
                                    Text("Create account")
                                        .ProBold(size: 15)
                                }
                                .cornerRadius(20)
                        }
                        .padding(.trailing)
                        
                        Button(action: {
                            isSign = true
                            UserDefaultsManager().quitQuest()
                        }) {
                            Rectangle()
                                .fill(Color(red: 255/255, green: 63/255, blue: 58/255))
                                .frame(width: 90, height: 40)
                                .overlay {
                                    Text("Log in")
                                        .ProBold(size: 15)
                                }
                                .cornerRadius(20)
                        }
                        .padding(.trailing)
                        
                        Spacer()
                        
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Rectangle()
                                .fill(Color(red: 255/255, green: 63/255, blue: 58/255))
                                .frame(width: 80, height: 40)
                                .overlay {
                                    Text("Back")
                                        .ProBold(size: 15)
                                }
                                .cornerRadius(20)
                        }
                        .padding(.trailing)
                    }
                }
            }
            .padding(.vertical)
        }
        .fullScreenCover(isPresented: $isSign) {
            SignUpView()
        }
    }
}

#Preview {
    StatisticView()
}

