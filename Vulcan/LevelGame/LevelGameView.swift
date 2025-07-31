import SwiftUI

struct LevelGameView: View {
    @StateObject var levelGameModel =  LevelGameViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State var isGame = false
    @State var isTime = false
    var body: some View {
        ZStack {
            Color(red: 1/255, green: 90/255, blue: 174/255).ignoresSafeArea()
            
            Image(.back)
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.white)
                            .font(.system(size: 24, weight: .semibold))
                    }
                    
                    Spacer()
                    
                    Text("Levels")
                        .ProBold(size: 24)
                        .padding(.trailing, 20)
                    
                    Spacer()
                }
                .padding(.top)
                .padding(.horizontal)
                
                Spacer()
                
                VStack(spacing: 25) {
                    Button(action: {
                        isTime = false
                        isGame = true
                    }) {
                        Rectangle()
                            .fill(Color(red: 255/255, green: 64/255, blue: 58/255))
                            .overlay {
                                RoundedRectangle(cornerRadius: 36)
                                    .stroke(.white, lineWidth: 2)
                                
                                Text("Endless level")
                                    .ProBold(size: 18)
                            }
                            .frame(width: 260, height: 60)
                            .cornerRadius(36)
                    }
                    
                    Button(action: {
                        isTime = true
                        isGame = true
                    }) {
                        Rectangle()
                            .fill(Color(red: 255/255, green: 64/255, blue: 58/255))
                            .overlay {
                                RoundedRectangle(cornerRadius: 36)
                                    .stroke(.white, lineWidth: 2)
                                
                                Text("Time level")
                                    .ProBold(size: 18)
                            }
                            .frame(width: 260, height: 60)
                            .cornerRadius(36)
                    }
                }
                
                Spacer()
            }
            .padding(.vertical)
        }
        .fullScreenCover(isPresented: $isGame) {
                 GameView(isTime: isTime)
             }
    }
}

#Preview {
    LevelGameView()
}
