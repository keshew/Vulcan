import SwiftUI

struct MainView: View {
    @StateObject var mainModel =  MainViewModel()
    @State var isStatistic = false
    @State var isMap = false
    @State var isGame = false
    @State var isAchiev = false
    
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

