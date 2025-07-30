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
    @StateObject var mapModel = MapViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State private var currentScale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    @State private var selectedVolcan: Volcan? = nil
    @State private var showExploredBanner = false
    @State private var showAchievementBanner = false
    @State private var activeAchievementIndex: Int? = nil
    
    let volcanoPositions: [CGPoint] = [
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
    
    @AppStorage("isFirstTime2") var isFirstTime2: Bool = true
    @State var currentIndex = 0
    var arrayOfMessage = ["There are different volcanoes on the map",
                          "By clicking on a volcano, detailed\ninformation about the volcano will open",
                          "Then you can click \"Explored\" and that volcano will be marked as explored, this will be displayed in the achievements screen"]
    
    var body: some View {
        ZStack {
            Color(red: 1/255, green: 90/255, blue: 174/255).ignoresSafeArea()
            
            Image(.back)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .ignoresSafeArea()
            
            ZStack {
                Image(.map2)
                    .resizable()
                    .ignoresSafeArea()
                
                Image(.shadow)
                    .resizable()
                    .frame(height: 160)
                    .ignoresSafeArea()
                    .offset(y: -135)
                
                ForEach(Array(mapModel.volcanoes.enumerated()), id: \.element.id) { index, volcan in
                    VStack {
                        Button(action: {
                            if !UserDefaultsManager().isGuest() {
                                selectedVolcan = volcan
                            }
                        }) {
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
                    }
                    .position(volcanoPositions.indices.contains(index) ? volcanoPositions[index] : .zero)
                }
                
                if isFirstTime2 {
                    Color.black.opacity(0.5).ignoresSafeArea()
                    
                    ForEach(Array(mapModel.volcanoes.enumerated()), id: \.element.id) { index, volcan in
                        VStack {
                            Button(action: {
                                if !UserDefaultsManager().isGuest() {
                                    selectedVolcan = volcan
                                }
                            }) {
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
                        }
                        .position(volcanoPositions.indices.contains(index) ? volcanoPositions[index] : .zero)
                        .opacity(isFirstTime2 && currentIndex == 1 && index != 0 ? 0 : 1)
                    }
                }
            }
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
                        },DragGesture())
            )
            .animation(.easeInOut, value: currentScale)
            
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
            
            if let volcan = selectedVolcan {
                Rectangle()
                    .fill(Color(red: 1/255, green: 90/255, blue: 174/255))
                    .overlay {
                        RoundedRectangle(cornerRadius: 36)
                            .stroke(Color(red: 18/255, green: 154/255, blue: 247/255), lineWidth: 3)
                            .overlay  {
                                HStack {
                                    Image(volcan.image)
                                        .resizable()
                                        .overlay {
                                            if !volcan.isExplored {
                                                Rectangle()
                                                    .fill(Color(red: 16/255, green: 145/255, blue: 234/255))
                                                    .overlay {
                                                        Text("You've found a new volcano!")
                                                            .Pro(size: 15)
                                                    }
                                                    .frame(width: 210, height: 30)
                                                    .cornerRadius(36)
                                                    .offset(y: -100)
                                            }
                                        }
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 260)
                                        .padding(.vertical)
                                    
                                    
                                    VStack(alignment: .leading, spacing: 7) {
                                        HStack {
                                            Text(volcan.name)
                                                .ProBold(size: 24)
                                            
                                            Spacer()
                                            
                                            Button(action: {
                                                selectedVolcan = nil
                                            }) {
                                                Image(systemName: "xmark")
                                                    .font(.system(size: 24, weight: .semibold))
                                                    .foregroundStyle(.white)
                                            }
                                        }
                                        
                                        Text(volcan.description)
                                            .Pro(size: 14)
                                        
                                        VStack(alignment: .leading) {
                                            Text("Contry: \(volcan.contry)")
                                                .Pro(size: 12)
                                            
                                            Text("Type: \(volcan.type)")
                                                .Pro(size: 12)
                                            
                                            Text("Activity: \(volcan.activity)")
                                                .Pro(size: 12)
                                        }
                                        
                                        Spacer()
                                        
                                        HStack {
                                            Spacer()
                                            
                                            Button(action: {
                                                markAsExplored(volcan)
                                                selectedVolcan = nil
                                            }) {
                                                Rectangle()
                                                    .fill(Color(red: 255/255, green: 64/255, blue: 58/255))
                                                    .overlay {
                                                        HStack {
                                                            Text("Explored!")
                                                                .ProBold(size: 18)
                                                            
                                                            Image(systemName: "checkmark")
                                                                .font(.system(size: 14, weight: .black))
                                                                .foregroundStyle(.white)
                                                        }
                                                    }
                                                    .frame(width: 150, height: 40)
                                                    .cornerRadius(36)
                                            }
                                        }
                                    }
                                    .padding(.trailing)
                                    .padding(.vertical, 15)
                                }
                            }
                    }
                    .frame(height: 250)
                    .cornerRadius(36)
                    .padding(.horizontal)
                    .padding(.top, 80)
            }
            
            if isFirstTime2 {
                if let volcan = selectedVolcan {
                    Rectangle()
                        .fill(.black.opacity(0.4))
                        .overlay {
                            RoundedRectangle(cornerRadius: 36)
                                .stroke(.clear, lineWidth: 3)
                                .overlay  {
                                    HStack {
                                        Image(volcan.image)
                                            .resizable()
                                            .overlay {
                                                if !volcan.isExplored {
                                                    Rectangle()
                                                        .fill(Color(red: 16/255, green: 145/255, blue: 234/255))
                                                        .overlay {
                                                            Text("You've found a new volcano!")
                                                                .Pro(size: 15)
                                                        }
                                                        .frame(width: 210, height: 30)
                                                        .cornerRadius(36)
                                                        .offset(y: -100)
                                                }
                                            }
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 260)
                                            .padding(.vertical)
                                            .hidden()
                                        
                                        VStack(alignment: .leading, spacing: 7) {
                                            HStack {
                                                Text(volcan.name)
                                                    .ProBold(size: 24)
                                                
                                                Spacer()
                                                
                                                Button(action: {
                                                    selectedVolcan = nil
                                                }) {
                                                    Image(systemName: "xmark")
                                                        .font(.system(size: 24, weight: .semibold))
                                                        .foregroundStyle(.white)
                                                }
                                            }
                                            .hidden()
                                            Text(volcan.description)
                                                .Pro(size: 14)
                                                .hidden()
                                            VStack(alignment: .leading) {
                                                Text("Contry: \(volcan.contry)")
                                                    .Pro(size: 12)
                                                
                                                Text("Type: \(volcan.type)")
                                                    .Pro(size: 12)
                                                
                                                Text("Activity: \(volcan.activity)")
                                                    .Pro(size: 12)
                                            }
                                            .hidden()
                                            Spacer()
                                            
                                            HStack {
                                                Spacer()
                                                
                                                Button(action: {
                                                    markAsExplored(volcan)
                                                    selectedVolcan = nil
                                                }) {
                                                    Rectangle()
                                                        .fill(Color(red: 255/255, green: 64/255, blue: 58/255))
                                                        .overlay {
                                                            HStack {
                                                                Text("Explored!")
                                                                    .ProBold(size: 18)
                                                                
                                                                Image(systemName: "checkmark")
                                                                    .font(.system(size: 14, weight: .black))
                                                                    .foregroundStyle(.white)
                                                            }
                                                        }
                                                        .frame(width: 150, height: 40)
                                                        .cornerRadius(36)
                                                }
                                            }
                                        }
                                        .padding(.trailing)
                                        .padding(.vertical, 15)
                                    }
                                }
                            
                        }
                        .frame(height: 250)
                        .cornerRadius(36)
                        .padding(.horizontal)
                        .padding(.top, 80)
                }
            }
            
            if isFirstTime2 {
                VStack(spacing: 0) {
                    Text(arrayOfMessage[currentIndex])
                        .ProOutline(size: 28, width: 1)
                        .padding()
                        .padding(.horizontal)
                        .multilineTextAlignment(.center)
                    
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
                            .overlay {
                                Text("I get it")
                                    .ProBold(size: 18)
                            }
                            .cornerRadius(16)
                    }
                    .padding(.horizontal, 300)
                }
                .padding(.top, 50)
            }
            
            if showExploredBanner {
                Image(.explored)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 350)
                    .padding(.top, 30)
                    .background(Color.black.opacity(0.001))
                    .animation(.easeInOut, value: showExploredBanner)
            }
            
            if let activeIdx = activeAchievementIndex {
                let achievement = mapModel.achievements[activeIdx]
                Image(achievement.imageName)
                    .resizable()
                    .overlay {
                        Button(action: {
                            withAnimation { activeAchievementIndex = nil }
                        }) {
                            Rectangle()
                                .fill(Color(red: 255/255, green: 64/255, blue: 58/255))
                                .overlay {
                                    HStack {
                                        Text("Ok")
                                            .ProBold(size: 16)
                                        
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 12, weight: .black))
                                            .foregroundStyle(.white)
                                    }
                                }
                                .frame(width: 90, height: 30)
                                .cornerRadius(36)
                        }
                        .offset(y: 75)
                    }
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 220)
                    .padding(.top, 70)
            }
        }
    }
    
    private func markAsExplored(_ volcan: Volcan) {
        if let idx = mapModel.volcanoes.firstIndex(where: { $0.id == volcan.id }) {
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
}

#Preview {
    MapView()
}
