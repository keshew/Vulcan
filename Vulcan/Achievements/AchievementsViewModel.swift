import SwiftUI

class AchievementsViewModel: ObservableObject {
    let contact = AchievementsModel()
    @Published var volcanoes: [Volcan] = []
    @Published var achievements: [Achievement] = []
    private let exploredCountKey = "exploredCount"
    
    @Published var exploredCount: Int = 0
    
    
    init() {
        loadVolcanoes()
        loadExploredCount()
        loadAchievements()
    }
    
    func loadExploredCount() {
        exploredCount = UserDefaults.standard.integer(forKey: exploredCountKey)
    }
    
    func incrementExploredCount() {
        exploredCount += 1
        UserDefaults.standard.set(exploredCount, forKey: exploredCountKey)
    }
    
    func resetExploredCount() {
        exploredCount = 0
        UserDefaults.standard.set(exploredCount, forKey: exploredCountKey)
    }
    
    func loadAchievements() {
        if let saved = UserDefaultsManager.shared.loadAchievements() {
            self.achievements = saved
        } else {
            self.achievements = (1...10).map { i in
                Achievement(id: i, imageName: "ach\(i)", isShown: false)
            }
            saveAchievements()
        }
    }
    
    func saveAchievements() {
        UserDefaultsManager.shared.saveAchievements(achievements)
    }
    
    func markAchievementShown(for index: Int) {
        guard achievements.indices.contains(index) else { return }
        achievements[index].isShown = true
        saveAchievements()
    }
    
    func loadVolcanoes() {
        if let saved = UserDefaultsManager.shared.loadVolcanoes() {
            volcanoes = saved
        } else {
            volcanoes =  [
                Volcan(image: "volcano1", name: "Mt. Fuji",
                       description: "Iconic volcanic mountain in Japan, known for its symmetrical cone.",
                       contry: "Japan", type: "Stratovolcano",
                       activity: "Dormant",
                       isSleep: true, isExplored: false),
                
                Volcan(image: "volcano2", name: "Etna",
                       description: "One of the most active volcanoes in Europe, dominating Sicily.",
                       contry: "Italy", type: "Stratovolcano",
                       activity: "Active",
                       isSleep: false, isExplored: false),
                
                Volcan(image: "volcano3", name: "Krakatoa",
                       description: "Famous for the catastrophic 1883 eruption.",
                       contry: "Indonesia", type: "Caldera",
                       activity: "Active",
                       isSleep: false, isExplored: false),
                
                Volcan(image: "volcano4", name: "Kīlauea",
                       description: "One of the most active shield volcanoes on Earth, located in Hawaii.",
                       contry: "United States", type: "Shield volcano",
                       activity: "Active",
                       isSleep: false, isExplored: false),
                
                Volcan(image: "volcano5", name: "Nyiragongo",
                       description: "Known for its fast-moving lava flows in the Democratic Republic of Congo.",
                       contry: "DR Congo", type: "Stratovolcano",
                       activity: "Active",
                       isSleep: false, isExplored: false),
                
                Volcan(image: "volcano6", name: "Ol Doinyo Lengai",
                       description: "Unique for its carbonatite lava in Tanzania.",
                       contry: "Tanzania", type: "Stratovolcano",
                       activity: "Active",
                       isSleep: false, isExplored: false),
                
                Volcan(image: "volcano7", name: "Popocatépetl",
                       description: "One of Mexico’s most active volcanoes with frequent ash emissions.",
                       contry: "Mexico", type: "Stratovolcano",
                       activity: "Active",
                       isSleep: false, isExplored: false),
                
                Volcan(image: "volcano8", name: "Mount Vesuvius",
                       description: "Famous for burying Pompeii in 79 AD; currently dormant.",
                       contry: "Italy", type: "Stratovolcano",
                       activity: "Dormant",
                       isSleep: true, isExplored: false),
                
                Volcan(image: "volcano9", name: "Mauna Loa",
                       description: "Largest active volcano on Earth, located in Hawaii.",
                       contry: "United States", type: "Shield volcano",
                       activity: "Active",
                       isSleep: false, isExplored: false)
            ]
            UserDefaultsManager().saveVolcanoes(volcanoes)
        }
    }
    
    func saveVolcanoes() {
        UserDefaultsManager.shared.saveVolcanoes(volcanoes)
    }
}
