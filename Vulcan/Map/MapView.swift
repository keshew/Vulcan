import SwiftUI

struct Volcan: Codable, Identifiable {
    var id = UUID().uuidString
    var image: String
    var name: String
    var description: String
    var contry: String
    var type: String
    var activity: String
    var isSleep: Bool
    var isExplored: Bool
}

struct Achievement: Codable, Identifiable {
    let id: Int
    let imageName: String
    var isShown: Bool
}

struct MapView: View {
    @StateObject private var mapModel = MapViewModel()
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var currentScale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    
    @State private var selectedVolcan: Volcan? = nil
    
    @State private var showExploredBanner = false
    @State private var showAchievementBanner = false
    @State private var activeAchievementIndex: Int? = nil
    
    let scaleX = 1024 / 440
    let scaleY = 1366 / 956
    
    private let volcanoPositions: [CGPoint] = [
        CGPoint(x: 100, y: 200),
        CGPoint(x: 150, y: 100),
        CGPoint(x: 400, y: 300),
        CGPoint(x: 350, y: 350),
        CGPoint(x: 600, y: 250),
        CGPoint(x: 700, y: 180),
        CGPoint(x: 450, y: 150),
        CGPoint(x: 550, y: 320),
        CGPoint(x: 100, y: 300),
        CGPoint(x: 250, y: 250),
        CGPoint(x: 500, y: 190),
        CGPoint(x: 650, y: 80),
        CGPoint(x: 300, y: 100),
        CGPoint(x: 590, y: 330),
        CGPoint(x: 50, y: 200)
    ]
    private let volcanoPositions2: [CGPoint] = [
        CGPoint(x: 700, y: 400),
        CGPoint(x: 850, y: 200),
        CGPoint(x: 200, y: 400),
        CGPoint(x: 750, y: 450),
        CGPoint(x: 800, y: 350),
        CGPoint(x: 900, y: 280),
        CGPoint(x: 650, y: 310),
        
        CGPoint(x: 150, y: 320),
        CGPoint(x: 100, y: 300),
        CGPoint(x: 250, y: 250),
        CGPoint(x: 450, y: 190),
        CGPoint(x: 630, y: 80),
        CGPoint(x: 300, y: 100),
        CGPoint(x: 410, y: 370),
        CGPoint(x: 250, y: 200)
    ]
    
    private let volcanoPositions3: [CGPoint] = [
        CGPoint(x: 750, y: 400),
        CGPoint(x: 850, y: 600),
        CGPoint(x: 200, y: 400),
        CGPoint(x: 750, y: 450),
        CGPoint(x: 900, y: 750),
        CGPoint(x: 900, y: 380),
        CGPoint(x: 530, y: 310),

        CGPoint(x: 190, y: 320),
        CGPoint(x: 100, y: 470),
        CGPoint(x: 250, y: 250),
        CGPoint(x: 450, y: 190),
        CGPoint(x: 530, y: 100),
        CGPoint(x: 300, y: 100),
        CGPoint(x: 460, y: 370),
        CGPoint(x: 250, y: 600)
    ]
    @AppStorage("isFirstTime2") private var isFirstTime2: Bool = true
    @State private var currentIndex = 0
    
    private let arrayOfMessage = [
        "There are different volcanoes on the map",
        "By clicking on a volcano, detailed\ninformation about the volcano will open",
        "Then you can click \"Explored\" and that volcano will be marked as explored, this will be displayed in the achievements screen"
    ]
    
    var body: some View {
        ZStack {
            backgroundColorView()
            backgroundImagesView()
            volcanoesButtonsLayer()
            firstTimeOverlay()
            mapGestures()
            topBar()
            volcanoDetailsView()
            firstTimeTutorialOverlay()
            exploredBannerView()
            achievementBannerView()
        }
    }
}

// MARK: - Extensions for readability and complexity

private extension MapView {
    
    @ViewBuilder
    func backgroundColorView() -> some View {
        Color(red: 1/255, green: 90/255, blue: 174/255)
            .ignoresSafeArea()
    }
    
    @ViewBuilder
    func backgroundImagesView() -> some View {
        ZStack {
            Image(.back)
                .resizable()
                .ignoresSafeArea()
            
            Image(.map2)
                .resizable()
                .ignoresSafeArea()
            
            Image(.shadow)
                .resizable()
                .frame(height: 160)
                .ignoresSafeArea()
                .offset(y: UIScreen.main.bounds.height > 1000 ? -430 : UIScreen.main.bounds.height > 800 ? -340 : -135)
        }
    }
    
    @ViewBuilder
    func volcanoesButtonsLayer() -> some View {
        Group {
            if !UserDefaultsManager().isGuest() {
                ZStack {
                    ForEach(Array(mapModel.volcanoes.enumerated()), id: \.element.id) { index, volcan in
                        volcanoButton(at: index, volcan: volcan)
                    }
                    
                    if isFirstTime2 {
                        Color.black.opacity(0.5).ignoresSafeArea()
                        
                        ForEach(Array(mapModel.volcanoes.enumerated()), id: \.element.id) { index, volcan in
                            volcanoButton(at: index, volcan: volcan, tutorialMode: true)
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func volcanoButton(at index: Int, volcan: Volcan, tutorialMode: Bool = false) -> some View {
        VStack {
            Button(action: {
                if !UserDefaultsManager().isGuest() {
                    selectedVolcan = volcan
                }
            }) {
                volcanoImage(for: volcan)
            }
        }
        .position(UIScreen.main.bounds.height > 1000  ? (volcanoPositions3.indices.contains(index) ? volcanoPositions3[index] : .zero) : UIScreen.main.bounds.height > 800 ? (volcanoPositions2.indices.contains(index) ? volcanoPositions2[index] : .zero) : (volcanoPositions.indices.contains(index) ? volcanoPositions[index] : .zero))
        .opacity(tutorialMode && currentIndex == 1 && index != 0 ? 0 : 1)
    }
    
    @ViewBuilder
    func volcanoImage(for volcan: Volcan) -> some View {
        if volcan.isSleep {
            Image("sleepVolcano")
                .resizable()
                .frame(width: 30, height: 30)
        } else {
            Image(.volcano)
                .resizable()
                .frame(width: 30, height: 30)
        }
    }
    
    @ViewBuilder
    func mapGestures() -> some View {
        Rectangle()
            .fill(Color.clear)
            .ignoresSafeArea()
            .scaleEffect(currentScale)
            .offset(offset)
            .gesture(
                SimultaneousGesture(
                    MagnificationGesture()
                        .onChanged { value in
                            currentScale = min(max(lastScale * value, 1.0), 5.0)
                        }
                        .onEnded { value in
                            currentScale = min(max(lastScale * value, 1.0), 5.0)
                            lastScale = currentScale
                        },
                    DragGesture()
                        .onChanged { value in
                            offset = CGSize(width: lastOffset.width + value.translation.width,
                                            height: lastOffset.height + value.translation.height)
                        }
                        .onEnded { _ in
                            lastOffset = offset
                        }
                )
            )
            .animation(.easeInOut, value: currentScale)
    }
    
    @ViewBuilder
    func topBar() -> some View {
        VStack(alignment: .leading) {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(.white)
                }
                Spacer()
                Text("Interactive map of volcanoes")
                    .ProBold(size: 34)
                Spacer()
            }
            .padding(.top)
            .padding(.horizontal)
            
            Spacer()
        }
        .padding(.vertical)
        .opacity(isFirstTime2 ? 0 : 1)
    }
    
    @ViewBuilder
    func volcanoDetailsView() -> some View {
        if let volcan = selectedVolcan {
            volcanoDetailsContainer(volcan: volcan)
                .frame(height: 250)
                .cornerRadius(36)
                .padding(.horizontal)
                .padding(.top, 80)
        }
    }
    
    @ViewBuilder
    func volcanoDetailsContainer(volcan: Volcan) -> some View {
        Rectangle()
            .fill(Color(red: 1/255, green: 90/255, blue: 174/255))
            .overlay {
                RoundedRectangle(cornerRadius: 36)
                    .stroke(Color(red: 18/255, green: 154/255, blue: 247/255), lineWidth: 3)
                    .overlay {
                        volcanoDetailsContent(volcan: volcan)
                    }
            }
    }
    
    @ViewBuilder
    func volcanoDetailsContent(volcan: Volcan) -> some View {
        HStack {
            volcanoImageDetailed(for: volcan)
            volcanDescriptionSection(volcan: volcan)
        }
    }
    
    @ViewBuilder
    func volcanoImageDetailed(for volcan: Volcan) -> some View {
        Image(volcan.image)
            .resizable()
            .overlay{
                RoundedRectangle(cornerRadius: 27)
                    .stroke(Color(red: 52/255, green: 122/255, blue: 190/255), lineWidth: 3)
            }
//            .aspectRatio(contentMode: .fit)
            .frame(width: 230)
            .cornerRadius(27)
            .padding(.vertical)
            .padding(.horizontal, 25)
            .overlay {
                if !volcan.isExplored {
                    newVolcanoBanner()
                        .offset(y: -100)
                }
            }
    }
    
    @ViewBuilder
    func newVolcanoBanner() -> some View {
        Rectangle()
            .fill(Color(red: 16/255, green: 145/255, blue: 234/255))
            .frame(width: 210, height: 30)
            .cornerRadius(36)
            .overlay {
                Text("You've found a new volcano!")
                    .Pro(size: 15)
            }
    }
    
    @ViewBuilder
    func volcanDescriptionSection(volcan: Volcan) -> some View {
        VStack(alignment: .leading, spacing: 7) {
            HStack {
                Text(volcan.name)
                    .ProBold(size: 24)
                Spacer()
                closeSelectedButton()
            }
            Text(volcan.description)
                .Pro(size: 14)
            
            volcanInfoDetails(volcan: volcan)
            
            Spacer()
            
            exploreButton(volcan: volcan)
        }
        .padding(.trailing)
        .padding(.vertical, 15)
    }
    
    @ViewBuilder
    func closeSelectedButton() -> some View {
        Button(action: { selectedVolcan = nil }) {
            Image(systemName: "xmark")
                .font(.system(size: 24, weight: .semibold))
                .foregroundStyle(.white)
        }
    }
    
    @ViewBuilder
    func volcanInfoDetails(volcan: Volcan) -> some View {
        VStack(alignment: .leading) {
            Text("Contry: \(volcan.contry)")
                .Pro(size: 12)
            Text("Type: \(volcan.type)")
                .Pro(size: 12)
            Text("Activity: \(volcan.activity)")
                .Pro(size: 12)
        }
    }
    
    @ViewBuilder
    func exploreButton(volcan: Volcan) -> some View {
        HStack {
            Spacer()
            Button(action: {
                markAsExplored(volcan)
                selectedVolcan = nil
            }) {
                Rectangle()
                    .fill(Color(red: 255/255, green: 64/255, blue: 58/255))
                    .frame(width: 150, height: 40)
                    .cornerRadius(36)
                    .overlay {
                        HStack {
                            Text("Explored!")
                                .ProBold(size: 18)
                            Image(systemName: "checkmark")
                                .font(.system(size: 14, weight: .black))
                                .foregroundStyle(.white)
                        }
                    }
            }
        }
    }
    
    @ViewBuilder
    func firstTimeTutorialOverlay() -> some View {
        if isFirstTime2 {
            VStack(spacing: 0) {
                Text(arrayOfMessage[currentIndex])
                    .ProOutline(size: 28, width: 1)
                    .padding()
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
                
                tutorialButton()
            }
            .padding(.top, 50)
        }
    }
    
    @ViewBuilder
    func tutorialButton() -> some View {
        Button(action: {
            if currentIndex <= 1 {
                if currentIndex == 1 {
                    selectedVolcan = mapModel.volcanoes[1]
                }
                currentIndex += 1
            } else {
                isFirstTime2 = false
                selectedVolcan = nil
            }
        }) {
            Rectangle()
                .fill(Color(red: 1/255, green: 45/255, blue: 160/255))
                .frame(height: 60)
                .cornerRadius(16)
                .overlay {
                    Text("I get it")
                        .ProBold(size: 18)
                }
                .padding(.horizontal, 300)
        }
    }
    
    @ViewBuilder
    func firstTimeOverlay() -> some View {
        if isFirstTime2 {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
        }
    }
    
    @ViewBuilder
    func exploredBannerView() -> some View {
        if showExploredBanner {
            Image(.explored)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 350)
                .padding(.top, 30)
                .background(Color.black.opacity(0.001))
                .animation(.easeInOut, value: showExploredBanner)
        }
    }
    
    @ViewBuilder
    func achievementBannerView() -> some View {
        if let activeIdx = activeAchievementIndex {
            let achievement = mapModel.achievements[activeIdx]
            Image(achievement.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 220)
                .padding(.top, 70)
                .overlay {
                    Button(action: {
                        withAnimation { activeAchievementIndex = nil }
                    }) {
                        Rectangle()
                            .fill(Color(red: 255/255, green: 64/255, blue: 58/255))
                            .frame(width: 90, height: 30)
                            .cornerRadius(36)
                            .overlay {
                                HStack {
                                    Text("Ok")
                                        .ProBold(size: 16)
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 12, weight: .black))
                                        .foregroundStyle(.white)
                                }
                            }
                    }
                    .offset(y: 105)
                }
        }
    }
    
    func markAsExplored(_ volcan: Volcan) {
        guard let idx = mapModel.volcanoes.firstIndex(where: { $0.id == volcan.id }) else { return }
        
        if mapModel.volcanoes[idx].isExplored == false {
            mapModel.volcanoes[idx].isExplored = true
            mapModel.saveVolcanoes()
            
            showExploredBanner = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation { showExploredBanner = false }
            }
        }
        
        mapModel.incrementExploredCount()
        
        if mapModel.exploredCount % 4 == 0 {
            if let achIndex = mapModel.achievements.firstIndex(where: { !$0.isShown }) {
                activeAchievementIndex = achIndex
                mapModel.markAchievementShown(for: achIndex)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    withAnimation { activeAchievementIndex = nil }
                }
            }
        }
    }
}

#Preview {
    MapView()
}
