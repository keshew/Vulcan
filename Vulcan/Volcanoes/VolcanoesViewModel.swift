import SwiftUI

class VolcanoesViewModel: ObservableObject {
    let contact = VolcanoesModel()
    @Published var volcan: Volcan? = nil
}
