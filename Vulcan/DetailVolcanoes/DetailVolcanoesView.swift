import SwiftUI

struct DetailVolcanoesView: View {
    @StateObject var DetailVolcanoesModel =  DetailVolcanoesViewModel()
    @State var currentIndex = 0
    let grid = [GridItem(.flexible()),
                GridItem(.flexible())]
    
    let cardWidth: CGFloat = 500
    let cardSpacing: CGFloat = 5
    
    let volcanoes: Volcan
    @Environment(\.presentationMode) var presentationMode
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
                    
                    Text("Volcanoes of \(volcanoes.contry)")
                        .ProBold(size: 24)
                        .padding(.trailing, 20)
                    
                    Spacer()
                }
                .padding(.top)
                .padding(.horizontal)
                
                Spacer()
                
                Rectangle()
                    .fill(Color(red: 1/255, green: 90/255, blue: 174/255))
                    .overlay {
                        RoundedRectangle(cornerRadius: 36)
                            .stroke(Color(red: 18/255, green: 154/255, blue: 247/255), lineWidth: 3)
                            .overlay  {
                                HStack(spacing: 10) {
                                    Image(volcanoes.image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 200)
                                        .padding()
                                    
                                    VStack(alignment: .leading, spacing: 7) {
                                        HStack {
                                            Text(volcanoes.name)
                                                .ProBold(size: 24)
                                            
                                            Spacer()
                                        }
                                        
                                        Text(volcanoes.description)
                                            .Pro(size: 14)
                                        
                                        VStack(alignment: .leading) {
                                            Text("Contry: \(volcanoes.contry)")
                                                .Pro(size: 12)
                                            
                                            Text("Type: \(volcanoes.type)")
                                                .Pro(size: 12)
                                            
                                            Text("Activity: \(volcanoes.activity)")
                                                .Pro(size: 12)
                                        }
                                        
                                        Spacer()
                                        
                                        HStack {
                                            Spacer()
                                            
                                            Button(action: {
                                                presentationMode.wrappedValue.dismiss()
                                            }) {
                                                Rectangle()
                                                    .fill(Color(red: 255/255, green: 64/255, blue: 58/255))
                                                    .overlay {
                                                        Text("Close")
                                                            .ProBold(size: 18)
                                                    }
                                                    .frame(width: 110, height: 40)
                                                    .cornerRadius(36)
                                            }
                                        }
                                        .padding(.trailing)
                                    }
                                    .padding(.trailing)
                                    .padding(.vertical, 25)
                                }
                            }
                    }
                    .frame(height: 250)
                    .cornerRadius(36)
                    .padding(.horizontal)
                
                Spacer()
            }
            .padding(.vertical)
        }
    }
}

#Preview {
    DetailVolcanoesView(volcanoes: Volcan(image: "", name: "", description: "", contry: "", type: "", activity: "", isSleep: false, isExplored: false))
}
