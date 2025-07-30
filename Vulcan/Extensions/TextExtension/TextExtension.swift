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
    
    func ProOutline(size: CGFloat,
              color: Color = .white,
                    colorOutline: Color = .black,
              width: CGFloat = 0.7) -> some View {
        self.font(.custom("SFProDisplay-Regular", size: size))
            .foregroundColor(color)
            .outlineText(color: colorOutline, width: width)
    }
}

import SwiftUI

extension View {
    func outlineText(color: Color, width: CGFloat) -> some View {
        modifier(StrokeModifier(strokeSize: width, strokeColor: color))
    }
}

struct StrokeModifier: ViewModifier {
    private let id = UUID()
    var strokeSize: CGFloat = 1
    var strokeColor: Color = .blue
    
    func body(content: Content) -> some View {
        content
            .padding(strokeSize*2)
            .background (Rectangle()
                .foregroundStyle(strokeColor)
                .mask({
                    outline(context: content)
                })
            )}
    
    func outline(context:Content) -> some View {
        Canvas { context, size in
            context.addFilter(.alphaThreshold(min: 0.01))
            context.drawLayer { layer in
                if let text = context.resolveSymbol(id: id) {
                    layer.draw(text, at: .init(x: size.width/2, y: size.height/2))
                }
            }
        } symbols: {
            context.tag(id)
                .blur(radius: strokeSize)
        }
    }
}
