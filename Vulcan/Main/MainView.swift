import SwiftUI

struct MainView: View {
    @StateObject var mainModel = MainViewModel()
    
    @State private var isStatistic: Bool = false
    @State private var isMap: Bool = false
    @State private var isGame: Bool = false
    @State private var isAchiev: Bool = false
    
    @AppStorage("isFirstTime") private var isFirstTime: Bool = true
    @State private var currentIndex: Int = 0
    
    private let bgColor = Color(red: 1/255, green: 90/255, blue: 174/255)
    private let dangerRed = Color(red: 255/255, green: 64/255, blue: 58/255)
    
    private let tutorialMessages: [String] = [
        "By clicking at this button,\nyou can see you statistic",
        "On the map you will learn more\nnew about volcanoes",
        "When you feel tired, you can\nplay in this simple game",
        "And here, you will see all achievments,\nyou can track your progress and\nread about volcanoes again"
    ]
    
    var body: some View {
        ZStack {
            backgroundLayer()
            backgroundImage()
            mainContent()
            tutorialOverlayIfNeeded()
        }
        .fullScreenCover(isPresented: $isStatistic) { StatisticView() }
        .fullScreenCover(isPresented: $isMap) { MapView() }
        .fullScreenCover(isPresented: $isGame) { LevelGameView() }
        .fullScreenCover(isPresented: $isAchiev) { AchievementsView() }
    }
    
    // MARK: - Background Color
    
    @ViewBuilder
    private func backgroundLayer() -> some View {
        bgColor.ignoresSafeArea()
    }
    
    // MARK: - Background Image
    
    @ViewBuilder
    private func backgroundImage() -> some View {
        Image(.back)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .ignoresSafeArea()
    }
    
    // MARK: - Main Content
    
    @ViewBuilder
    private func mainContent() -> some View {
        VStack(alignment: .leading) {
            headerSection()
            Spacer()
            buttonsRow()
        }
        .padding(.vertical)
    }
    
    // MARK: - Header Section
    
    @ViewBuilder
    private func headerSection() -> some View {
        HStack {
            Text("Main")
                .ProBold(size: 34)
            
            Spacer()
            
            coinsButton()
            
            settingsButton()
        }
        .padding(.top)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private func coinsButton() -> some View {
        
        Rectangle()
            .fill(dangerRed)
            .frame(width: 80, height: 40)
            .cornerRadius(12)
            .overlay {
                HStack(spacing: 5) {
                    Image(.stars)
                        .resizable()
                        .frame(width: 30, height: 30)
                    
                    if UserDefaultsManager().isGuest() {
                        Text("0").ProBold(size: 20)
                    } else {
                        Text("\(UserDefaultsManager().getCoins())").ProBold(size: 20)
                    }
                }
            }
        
    }
    
    @ViewBuilder
    private func settingsButton() -> some View {
        Button(action: {
            isStatistic = true
        }) {
            Image(.settings)
                .resizable()
                .frame(width: 40, height: 40)
        }
    }
    
    // MARK: - Buttons Row
    
    @ViewBuilder
    private func buttonsRow() -> some View {
        HStack(spacing: 30) {
            mapButton()
            gameButton()
            achievementsButton()
        }
        .padding()
    }
    
    @ViewBuilder
    private func mapButton() -> some View {
        Button(action: {
            isMap = true
        }) {
            Image(.map)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
    
    @ViewBuilder
    private func gameButton() -> some View {
        Button(action: {
            isGame = true
        }) {
            Image(.lava)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
    
    @ViewBuilder
    private func achievementsButton() -> some View {
        Button(action: {
            isAchiev = true
        }) {
            Image(.achiev)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
    
    // MARK: - Tutorial Overlay
    
    @ViewBuilder
    private func tutorialOverlayIfNeeded() -> some View {
        if isFirstTime {
            Color.black.opacity(0.5).ignoresSafeArea()
            tutorialContent()
        }
    }
    
    @ViewBuilder
    private func tutorialContent() -> some View {
        VStack(alignment: .leading) {
            tutorialHeader()
            Spacer()
            tutorialButtonsRow()
        }
        .padding(.vertical)
        .overlay(tutorialMessageOverlay())
    }
    
    @ViewBuilder
    private func tutorialHeader() -> some View {
        HStack {
            Text("Main").ProBold(size: 34).hidden()
            Spacer()
            tutorialSettingsButton()
        }
        .padding(.top)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private func tutorialSettingsButton() -> some View {
        Button(action: { isStatistic = true })
        {
            Image(.settings)
                .resizable()
                .frame(width: 40, height: 40)
        }
        .opacity(currentIndex == 0 ? 1 : 0)
    }
    
    @ViewBuilder
    private func tutorialButtonsRow() -> some View {
        HStack(spacing: 30) {
            tutorialMapButton()
                .opacity(currentIndex == 1 ? 1 : 0)
            tutorialGameButton()
                .opacity(currentIndex == 2 ? 1 : 0)
            tutorialAchievementsButton()
                .opacity(currentIndex == 3 ? 1 : 0)
        }
        .padding()
    }
    
    @ViewBuilder
    private func tutorialMapButton() -> some View {
        Button(action: { isMap = true }) {
            Image(.map)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
    
    @ViewBuilder
    private func tutorialGameButton() -> some View {
        Button(action: { isGame = true }) {
            Image(.lava)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
    
    @ViewBuilder
    private func tutorialAchievementsButton() -> some View {
        Button(action: { isAchiev = true }) {
            Image(.achiev)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
    
    @ViewBuilder
    private func tutorialMessageOverlay() -> some View {
        VStack(spacing: 20) {
            Text(tutorialMessages[currentIndex])
                .ProOutline(size: 25, width: 1)
                .multilineTextAlignment(.center)
                .padding()
                .padding(.horizontal)
            
            tutorialNextButton()
        }
        .padding(.top, 50)
        .offset(x: tutorialMessageOffset())
    }
    
    @ViewBuilder
    private func tutorialNextButton() -> some View {
        Button(action: {
            if currentIndex < tutorialMessages.count - 1 {
                currentIndex += 1
            } else {
                isFirstTime = false
            }
        }) {
            Rectangle()
                .fill(Color(red: 1/255, green: 45/255, blue: 160/255))
                .frame(height: 60)
                .cornerRadius(16)
                .overlay(Text("I get it").ProBold(size: 21))
                .padding(.horizontal, 300)
        }
    }
    
    private func tutorialMessageOffset() -> CGFloat {
        switch currentIndex {
        case 1:
            return 50
        case 2:
            return -250
        case 3:
            return -120
        default:
            return 0
        }
    }
}

#Preview {
    MainView()
}


