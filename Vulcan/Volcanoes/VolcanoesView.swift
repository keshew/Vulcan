import SwiftUI

struct VolcanoesView: View {
    @StateObject var volcanoesModel =  VolcanoesViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    @State var currentIndex = 0
    let grid = [GridItem(.flexible()),
                GridItem(.flexible())]
    
    let cardWidth: CGFloat = 500
    let cardSpacing: CGFloat = 5
    
    let volcanoes: [Volcan]
    @State var isDetail = false
    
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
                    
                    Text("Volcanoes of \(volcanoes.first?.contry ?? "")")
                        .ProBold(size: 24)
                        .padding(.trailing, 20)
                    
                    Spacer()
                }
                .padding(.top)
                .padding(.horizontal)
                
                Spacer()
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: cardSpacing) {
                        ForEach(volcanoes.indices, id: \.self) { index in
                            let volcan = volcanoes[index]
                            if volcan.isExplored {
                                Rectangle()
                                    .fill(Color(red: 1/255, green: 90/255, blue: 174/255))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 36)
                                            .stroke(Color(red: 18/255, green: 154/255, blue: 247/255), lineWidth: 3)
                                            .overlay  {
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
                                    }
                                    .frame(width: 500, height: 200)
                                    .cornerRadius(36)
                                    .padding(.horizontal)
                                    .background(GeometryReader { geo -> Color in
                                        let frame = geo.frame(in: .global)
                                        let screenCenter = UIScreen.main.bounds.width / 2
                         
                                        let cardCenter = frame.midX
                                        DispatchQueue.main.async {
                                            withAnimation(.easeInOut) {
                                                let newIndex = Int(round((cardCenter - screenCenter) / (cardWidth + cardSpacing)))
                                                let clampedIndex = min(max(-newIndex, 0), 5)
                                                if clampedIndex != currentIndex {
                                                    currentIndex = clampedIndex
                                                }
                                            }
                                        }
                                        return Color.clear
                                    })
                                    .onTapGesture {
                                        volcanoesModel.volcan = volcan
                                        isDetail = true
                                    }
                            } else {
                                Rectangle()
                                    .fill(Color(red: 1/255, green: 90/255, blue: 174/255))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 36)
                                            .stroke(Color(red: 18/255, green: 154/255, blue: 247/255), lineWidth: 3)
                                            .overlay  {
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
                                    }
                                    .frame(width: 500, height: 200)
                                    .cornerRadius(36)
                                    .padding(.horizontal)
                                    .background(GeometryReader { geo -> Color in
                                        let frame = geo.frame(in: .global)
                                        let screenCenter = UIScreen.main.bounds.width / 2
                         
                                        let cardCenter = frame.midX
                                        DispatchQueue.main.async {
                                            withAnimation(.easeInOut) {
                                                let newIndex = Int(round((cardCenter - screenCenter) / (cardWidth + cardSpacing)))
                                                let clampedIndex = min(max(-newIndex, 0), 5)
                                                if clampedIndex != currentIndex {
                                                    currentIndex = clampedIndex
                                                }
                                            }
                                        }
                                        return Color.clear
                                    })
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
                
                HStack(spacing: 13) {
                    ForEach(0..<volcanoes.count, id: \.self) { index in
                        Circle()
                            .fill(currentIndex == index ? .white : .clear)
                            .frame(width: currentIndex == index ? 16 : 12, height: currentIndex == index ? 16 : 12)
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 1)
                            )
                    }
                    
                    Spacer()
                    
                    Rectangle()
                        .foregroundStyle(.clear)
                        .overlay {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white)
                                .overlay {
                                    let exploredVolcanoes = volcanoes.filter { $0.isExplored }
                                    Text("\(exploredVolcanoes.count) | \(volcanoes.count)")
                                        .Pro(size: 12)
                                }
                        }
                        .frame(width: 45, height: 23)
                        .cornerRadius(16)
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .fullScreenCover(isPresented: $isDetail) {
            DetailVolcanoesView(volcanoes: volcanoesModel.volcan ?? Volcan(image: "", name: "", description: "", contry: "", type: "", activity: "", isSleep: false, isExplored: false))
        }
    }
}

#Preview {
    VolcanoesView(volcanoes: [Volcan(image: "", name: "", description: "", contry: "", type: "", activity: "", isSleep: false, isExplored: false)])
}

