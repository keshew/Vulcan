import SwiftUI

struct VolcanoesView: View {
    @StateObject private var volcanoesModel = VolcanoesViewModel()
    @Environment(\.presentationMode) private var presentationMode
    
    // MARK: - States and properties
    
    @State private var currentIndex: Int = 0
    @State private var isDetail: Bool = false
    
    private let grid = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    private let cardWidth: CGFloat = 500
    private let cardSpacing: CGFloat = 5
    
    let volcanoes: [Volcan]
    
    var body: some View {
        ZStack {
            backgroundColor()
            backgroundImage()
            mainContent()
        }
        .fullScreenCover(isPresented: $isDetail) {
            DetailVolcanoesView(volcanoes: volcanoesModel.volcan ?? placeholderVolcano())
        }
    }
    
    // MARK: - Background views
    
    @ViewBuilder
    private func backgroundColor() -> some View {
        Color(red: 1/255, green: 90/255, blue: 174/255)
            .ignoresSafeArea()
    }
    
    @ViewBuilder
    private func backgroundImage() -> some View {
        Image(.back)
            .resizable()
            .ignoresSafeArea()
    }
    
    // MARK: - Main content stack
    
    @ViewBuilder
    private func mainContent() -> some View {
        VStack(alignment: .leading) {
            headerSection()
            Spacer()
            volcanoCardsScrollView()
            Spacer()
            footerSection()
        }
        .padding(.vertical)
    }
    
    // MARK: - Header
    
    @ViewBuilder
    private func headerSection() -> some View {
        HStack {
            backButton()
            Spacer()
            titleText()
            Spacer()
        }
        .padding(.top)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private func backButton() -> some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "chevron.left")
                .foregroundStyle(.white)
                .font(.system(size: 24, weight: .semibold))
        }
    }
    
    @ViewBuilder
    private func titleText() -> some View {
        Text("Volcanoes of \(volcanoes.first?.contry ?? "")")
            .ProBold(size: 24)
            .padding(.trailing, 20)
    }
    
    // MARK: - Volcano Cards ScrollView
    
    @ViewBuilder
    private func volcanoCardsScrollView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: cardSpacing) {
                ForEach(volcanoes.indices, id: \.self) { index in
                    volcanoCard(for: volcanoes[index], at: index)
                }
            }
            .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    private func volcanoCard(for volcan: Volcan, at index: Int) -> some View {
        Group {
            if volcan.isExplored {
                exploredVolcanoCard(volcan, index: index)
            } else {
                unexploredVolcanoCard(index: index)
            }
        }
    }
    
    @ViewBuilder
    private func exploredVolcanoCard(_ volcan: Volcan, index: Int) -> some View {
        cardBase()
            .overlay {
                exploredVolcanoOverlay(volcan)
            }
            .frame(width: cardWidth, height: 200)
            .cornerRadius(36)
            .padding(.horizontal)
            .background(indexGeometryBackground(index: index))
            .onTapGesture {
                volcanoesModel.volcan = volcan
                isDetail = true
            }
    }
    
    @ViewBuilder
    private func unexploredVolcanoCard(index: Int) -> some View {
        cardBase()
            .overlay {
                unexploredVolcanoOverlay()
            }
            .frame(width: cardWidth, height: 200)
            .cornerRadius(36)
            .padding(.horizontal)
            .background(indexGeometryBackground(index: index))
    }
    
    @ViewBuilder
    private func cardBase() -> some View {
        Rectangle()
            .fill(Color(red: 1/255, green: 90/255, blue: 174/255))
            .cornerRadius(36)
            .overlay(
                RoundedRectangle(cornerRadius: 36)
                    .stroke(Color(red: 18/255, green: 154/255, blue: 247/255), lineWidth: 3)
            )
    }
    
    @ViewBuilder
    private func exploredVolcanoOverlay(_ volcan: Volcan) -> some View {
        HStack(spacing: 5) {
            Image(volcan.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 210)
                .padding(.vertical)
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(volcan.name)
                        .ProBold(size: 24)
                    Spacer()
                }
                
                Text(volcan.description)
                    .Pro(size: 14)
                
                Spacer()
            }
            .padding(.trailing)
            .padding(.vertical)
        }
    }
    
    @ViewBuilder
    private func unexploredVolcanoOverlay() -> some View {
        HStack(spacing: 5) {
            Image("volcMock")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 210)
                .padding(.vertical)
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Unknown volcano")
                        .ProBold(size: 24)
                    Spacer()
                }
                
                Text("Explore the map to discover this volcano")
                    .Pro(size: 14)
            }
            .padding(.trailing)
            .padding(.vertical)
        }
    }
    
    // MARK: - GeometryReader for paging
    
    private func indexGeometryBackground(index: Int) -> some View {
        GeometryReader { geo -> Color in
            let frame = geo.frame(in: .global)
            let screenCenter = UIScreen.main.bounds.width / 2
            let cardCenter = frame.midX
            
            DispatchQueue.main.async {
                withAnimation(.easeInOut) {
                    let newIndex = Int(round((cardCenter - screenCenter) / (cardWidth + cardSpacing)))
                    let clampedIndex = min(max(-newIndex, 0), volcanoes.count - 1)
                    if clampedIndex != currentIndex {
                        currentIndex = clampedIndex
                    }
                }
            }
            return Color.clear
        }
    }
    
    // MARK: - Footer Section (Dots and count)
    
    @ViewBuilder
    private func footerSection() -> some View {
        HStack(spacing: 13) {
            dotsIndicators()
            Spacer()
            exploredCountBadge()
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private func dotsIndicators() -> some View {
        ForEach(0..<volcanoes.count, id: \.self) { index in
            Circle()
                .fill(currentIndex == index ? .white : .clear)
                .frame(width: currentIndex == index ? 16 : 12, height: currentIndex == index ? 16 : 12)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 1)
                )
        }
    }
    
    @ViewBuilder
    private func exploredCountBadge() -> some View {
        let exploredVolcanoes = volcanoes.filter { $0.isExplored }
        Rectangle()
            .foregroundStyle(.clear)
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white)
                    .overlay {
                        Text("\(exploredVolcanoes.count) | \(volcanoes.count)")
                            .Pro(size: 12)
                    }
            }
            .frame(width: 45, height: 23)
            .cornerRadius(16)
    }
    
    // MARK: - Helpers
    
    private func placeholderVolcano() -> Volcan {
        Volcan(image: "", name: "", description: "", contry: "", type: "", activity: "", isSleep: false, isExplored: false)
    }
}

#Preview {
    VolcanoesView(volcanoes: [Volcan(image: "", name: "", description: "", contry: "", type: "", activity: "", isSleep: false, isExplored: false)])
}

