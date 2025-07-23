import SwiftUI

struct CardItem: Identifiable {
    let id = UUID()
    let title: String
    let progress: String
}

struct Card: Identifiable {
    let id = UUID()
    let title: String
    let items: [CardItem]
}

struct ScrollViewOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct VolcanoCollection: Identifiable {
    let id = UUID()
    let volcanoes: [Volcan]
}

struct AchievementsView: View {
    @StateObject var achievementsModel =  AchievementsViewModel()
    
    @Environment(\.presentationMode) var presentationMode
    @State var currentIndex = 0
    let grid = [GridItem(.flexible()),
                GridItem(.flexible())]
    
    let cardWidth: CGFloat = 600
    let cardSpacing: CGFloat = 16
    
    @State private var selectedVolcanoes: VolcanoCollection? = nil
    @State private var isValocs = false
    
    func progress(for filter: (Volcan) -> Bool) -> String {
        let filtered = achievementsModel.volcanoes.filter(filter)
        let exploredCount = filtered.filter { $0.isExplored }.count
        return "\(exploredCount) | \(filtered.count)"
    }
    
    var cards: [Card] {
        [
            Card(
                title: "Volcano collections",
                items: [
                    CardItem(title: "Volcanoes of Japan", progress: progress { $0.contry == "Japan" }),
                    CardItem(title: "Italy", progress: progress { $0.contry == "Italy" }),
                    CardItem(title: "United States America", progress: progress { $0.contry == "United States" }),
                    CardItem(title: "Indonesia", progress: progress { $0.contry == "Indonesia" }),
                ]
            ),
            Card(
                title: "Types of volcanoes",
                items: [
                    CardItem(title: "Shield volcano", progress: progress { $0.type == "Shield volcano" }),
                    CardItem(title: "Stratovolcano", progress: progress { $0.type == "Stratovolcano" }),
                ]
            ),
            Card(
                title: "Active volcanoes",
                items: [
                    CardItem(title: "Sleep volcano", progress: progress { $0.isSleep }),
                    CardItem(title: "Awake volcano", progress: progress { !$0.isSleep }),
                ]
            )
        ]
    }
    
    var body: some View {
        ZStack {
            Color(red: 1/255, green: 90/255, blue: 174/255).ignoresSafeArea()
            
            Image(.back)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.white)
                            .font(.system(size: 24, weight: .semibold))
                    }
                    
                    Spacer()
                    
                    Text("Achievements")
                        .ProBold(size: 34)
                        .padding(.trailing, 20)
                    
                    Spacer()
                }
                .padding(.top)
                .padding(.horizontal)
                
                Spacer()
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: cardSpacing) {
                        ForEach(cards) { card in
                            Rectangle()
                                .fill(Color(red: 1/255, green: 90/255, blue: 174/255))
                                .frame(width: cardWidth, height: 200)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 46)
                                        .stroke(Color(red: 18/255, green: 154/255, blue: 247/255), lineWidth: 3)
                                        .overlay {
                                            VStack(alignment: .leading, spacing: 10) {
                                                Text(card.title)
                                                    .ProBold(size: 22)
                                                    .padding(.leading, 30)
                                                
                                                LazyVGrid(columns: grid) {
                                                    ForEach(card.items) { item in
                                                        Rectangle()
                                                            .fill(Color(red: 1/255, green: 78/255, blue: 151/255))
                                                            .overlay {
                                                                HStack {
                                                                    Text(item.title)
                                                                        .Pro(size: 13)
                                                                    Spacer()
                                                                    Rectangle()
                                                                        .foregroundStyle(.clear)
                                                                        .overlay {
                                                                            RoundedRectangle(cornerRadius: 16)
                                                                                .stroke(.white)
                                                                                .overlay {
                                                                                    Text(item.progress)
                                                                                        .Pro(size: 12)
                                                                                }
                                                                        }
                                                                        .frame(width: 45, height: 23)
                                                                        .cornerRadius(16)
                                                                }
                                                                .padding(.horizontal)
                                                            }
                                                            .frame(height: 50)
                                                            .cornerRadius(36)
                                                            .onTapGesture {
                                                                if !UserDefaultsManager().isGuest() {
                                                                    let filtered = achievementsModel.volcanoes.filter { volcan in
                                                                        filterVolcano(volcan, cardTitle: card.title, itemTitle: item.title)
                                                                    }
                                                                    selectedVolcanoes = VolcanoCollection(volcanoes: filtered)
                                                                }
                                                            }
                                                    }
                                                }
                                                .padding(.horizontal, 30)
                                                
                                                Spacer()
                                            }
                                            .padding(.vertical, 20)
                                        }
                                }
                                .cornerRadius(46)
                                .background(GeometryReader { geo -> Color in
                                    let frame = geo.frame(in: .global)
                                    let screenCenter = UIScreen.main.bounds.width / 2
                                    
                                    let cardCenter = frame.midX
                                    DispatchQueue.main.async {
                                        let newIndex = Int(round((cardCenter - screenCenter) / (cardWidth + cardSpacing)))
                                        let clampedIndex = min(max(-newIndex, 0), 2)
                                        if clampedIndex != currentIndex {
                                            currentIndex = clampedIndex
                                        }
                                    }
                                    return Color.clear
                                })
                        }
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
            }
            .padding(.vertical)
        }
        .fullScreenCover(item: $selectedVolcanoes) { collection in
            VolcanoesView(volcanoes: collection.volcanoes)
        }
    }
    
    func filterVolcano(_ volcan: Volcan, cardTitle: String, itemTitle: String) -> Bool {
        let volcanCountry = volcan.contry.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let volcanType = volcan.type.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let itemTitleLower = itemTitle.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        switch cardTitle {
        case "Volcano collections":
            return volcanCountry.contains(itemTitleLower) || itemTitleLower.contains(volcanCountry)
        case "Types of volcanoes":
            return volcanType == itemTitleLower
        case "Active volcanoes":
            if itemTitleLower == "sleep volcano" {
                return volcan.isSleep
            } else if itemTitleLower == "awake volcano" {
                return !volcan.isSleep
            }
            return false
        default:
            return false
        }
    }
}

#Preview {
    AchievementsView()
}
