import SwiftUI

extension Text {
    func Pro(size: CGFloat,
             color: Color = .white)  -> some View {
        self.font(.custom("SFProDisplay-Regular", size: size))
            .foregroundColor(color)
    }
    
    func ProBold(size: CGFloat,
            color: Color = .white)  -> some View {
        self.font(.custom("SFProDisplay-Bold", size: size))
            .foregroundColor(color)
    }
}
