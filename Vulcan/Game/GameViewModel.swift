import SwiftUI
import Combine

class GameViewModel: ObservableObject {
    let contact = GameModel()
    @Published var isGameOver = false
    @Published var score = 0
    @Published var allScores: [Int] = []

    private let scoresKey = "gameScores"

    init() {
        loadScores()
    }
    
    var highestScoreExcludingCurrent: Int {
        var scoresCopy = allScores
        if let index = scoresCopy.firstIndex(of: score) {
            scoresCopy.remove(at: index)
        }
        return scoresCopy.max() ?? 0
    }
    
    func addScore(_ score: Int) {
        allScores.append(score)
        saveScores()
    }
    
    func saveScores() {
        UserDefaults.standard.set(allScores, forKey: scoresKey)
    }
    
    func loadScores() {
        if let savedScores = UserDefaults.standard.array(forKey: scoresKey) as? [Int] {
            allScores = savedScores
        }
    }
    
    let resetGamePublisher = PassthroughSubject<Void, Never>()

    func resetGame() {
        score = 0
        isGameOver = false
        resetGamePublisher.send()
    }
}
