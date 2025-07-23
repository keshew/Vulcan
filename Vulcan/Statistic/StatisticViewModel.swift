import SwiftUI

class StatisticViewModel: ObservableObject {
    let contact = StatisticModel()
    @Published var yourRecord: Int = 0
    @Published var worldRecord: Int = 6312
    @Published var consecutiveDays: Int = 0
    @Published var viewedVolcanoesCount: Int = 0 
    
    init() {
        loadData()
    }
    
    func loadData() {
        if let savedScores = UserDefaults.standard.array(forKey: "gameScores") as? [Int] {
                yourRecord = savedScores.max() ?? 0
            } else {
                yourRecord = 0
            }
        consecutiveDays = UserDefaultsManager.shared.getConsecutiveDays()
        viewedVolcanoesCount = UserDefaults.standard.integer(forKey: "exploredCount")
    }
}
