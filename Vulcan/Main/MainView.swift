import SwiftUI

struct MainView: View {
    @StateObject var mainModel =  MainViewModel()
    @State var isStatistic = false
    @State var isMap = false
    @State var isGame = false
    @State var isAchiev = false
    
    @AppStorage("isFirstTime") var isFirstTime: Bool = true
    @State var currentIndex = 0
    var arrayOfMessage = ["By clicking at this button,\nyou can see you statistic",
                          "On the map you will learn more\nnew about volcanoes",
                          "When you feel tired, you can\nplay in this simple game",
                          "And here, you will see all achievments,\nyou can track your progress and\nread about volcanoes again"]
    
    var body: some View {
        ZStack {
            Color(red: 1/255, green: 90/255, blue: 174/255).ignoresSafeArea()
            
            Image(.back)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                HStack {
                    Text("Main")
                        .ProBold(size: 34)
                    
                    Spacer()
                    
                    Button(action: {
                        
                    }) {
                        Rectangle()
                            .fill(Color(red: 255/255, green: 64/255, blue: 58/255))
                            .overlay {
                                HStack(spacing: 5) {
                                    Image(.stars)
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                    
                                    if UserDefaultsManager().isGuest() {
                                        Text("0")
                                            .ProBold(size: 20)
                                    } else {
                                        Text("\(UserDefaultsManager().getCoins())")
                                            .ProBold(size: 20)
                                    }
                                }
                            }
                            .frame(width: 80, height: 40)
                            .cornerRadius(12)
                    }
                    
                    Button(action: {
                        isStatistic = true
                    }) {
                        Image(.settings)
                            .resizable()
                            .frame(width: 40, height: 40)
                    }
                }
                .padding(.top)
                .padding(.horizontal)
                
                Spacer()
                
                HStack(spacing: 30) {
                    Button(action: {
                        isMap = true
                    }) {
                        Image(.map)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    
                    Button(action: {
                        isGame = true
                    }) {
                        Image(.lava)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    
                    Button(action: {
                        isAchiev = true
                    }) {
                        Image(.achiev)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                }
                .padding()
            }
            .padding(.vertical)
            
            if isFirstTime {
                Color.black.opacity(0.5).ignoresSafeArea()
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("Main")
                            .ProBold(size: 34)
                            .hidden()
                        
                        Spacer()
                        
                        Rectangle()
                            .fill(Color(red: 255/255, green: 64/255, blue: 58/255))
                            .overlay {
                                HStack(spacing: 5) {
                                    Image(.stars)
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                    
                                    if UserDefaultsManager().isGuest() {
                                        Text("0")
                                            .ProBold(size: 20)
                                    } else {
                                        Text("\(UserDefaultsManager().getCoins())")
                                            .ProBold(size: 20)
                                    }
                                }
                            }
                            .frame(width: 80, height: 40)
                            .cornerRadius(12)
                            .hidden()
                        
                        Button(action: {
                            isStatistic = true
                        }) {
                            Image(.settings)
                                .resizable()
                                .frame(width: 40, height: 40)
                        }
                        .opacity(currentIndex == 0 ? 1 : 0)
                    }
                    .padding(.top)
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    HStack(spacing: 30) {
                        Button(action: {
                            isMap = true
                        }) {
                            Image(.map)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                        .opacity(currentIndex == 1 ? 1 : 0)
                        
                        Button(action: {
                            isGame = true
                        }) {
                            Image(.lava)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                        .opacity(currentIndex == 2 ? 1 : 0)
                        
                        Button(action: {
                            isAchiev = true
                        }) {
                            Image(.achiev)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                        .opacity(currentIndex == 3 ? 1 : 0)
                    }
                    .padding()
                }
                .padding(.vertical)
                .overlay {
                    VStack(spacing: 20) {
                        Text(arrayOfMessage[currentIndex])
                            .ProOutline(size: 25, width: 1)
                            .padding()
                            .padding(.horizontal)
                            .multilineTextAlignment(.center)
                        
                        Button(action: {
                                if currentIndex <= 2 {
                                    currentIndex += 1
                                } else {
                                    isFirstTime = false
                                }
                            
                        }) {
                            Rectangle()
                                .fill(Color(red: 1/255, green: 45/255, blue: 160/255))
                                .frame(height: 60)
                                .overlay {
                                    Text("I get it")
                                        .ProBold(size: 21)
                                }
                                .cornerRadius(16)
                        }
                        .padding(.horizontal, 300)
                    }
                    .padding(.top, 50)
                    .offset(x: currentIndex == 1 ? 50 : currentIndex == 2 ? -250 : currentIndex == 3 ? -120 : 0)
                }
            }
        }
        .fullScreenCover(isPresented: $isStatistic) {
            StatisticView()
        }
        .fullScreenCover(isPresented: $isMap) {
            MapView()
        }
        .fullScreenCover(isPresented: $isGame) {
            GameView()
        }
        .fullScreenCover(isPresented: $isAchiev) {
            AchievementsView()
        }
    }
}

#Preview {
    MainView()
}

