import SwiftUI

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private let key = "savedVolcanoes"
    private let lastVisitDateKey = "lastVisitDate"
    private let consecutiveDaysKey = "consecutiveDays"
    
    func enterAsGuest() {
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "guest")
    }
   
    func saveName(_ name: String) {
        let defaults = UserDefaults.standard
        defaults.set(name, forKey: "name")
    }
    
    func getName() -> String? {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: "name")
    }
    
    func deleteName() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "name")
    }
    
    func isGuest() -> Bool {
        let defaults = UserDefaults.standard
        return defaults.bool(forKey: "guest")
    }
    
    func quitQuest() {
        let defaults = UserDefaults.standard
        defaults.set(false, forKey: "guest")
    }
    
    func checkLogin() -> Bool {
        let defaults = UserDefaults.standard
        return defaults.bool(forKey: "isLoggedIn")
    }
    
    func saveLoginStatus(_ isLoggedIn: Bool) {
        let defaults = UserDefaults.standard
        defaults.set(isLoggedIn, forKey: "isLoggedIn")
    }
    
    func saveVolcanoes(_ volcanoes: [Volcan]) {
        do {
            let data = try JSONEncoder().encode(volcanoes)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Error saving volcanoes: \(error)")
        }
    }
    
    func loadVolcanoes() -> [Volcan]? {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return nil
        }
        do {
            return try JSONDecoder().decode([Volcan].self, from: data)
        } catch {
            print("Error loading volcanoes: \(error)")
            return nil
        }
    }
    
    private let achievementsKey = "savedAchievements"
    
    func saveAchievements(_ achievements: [Achievement]) {
        do {
            let data = try JSONEncoder().encode(achievements)
            UserDefaults.standard.set(data, forKey: achievementsKey)
        } catch {
            print("Failed to save achievements: \(error)")
        }
    }
    
    func loadAchievements() -> [Achievement]? {
        guard let data = UserDefaults.standard.data(forKey: achievementsKey) else {
            return nil
        }
        do {
            return try JSONDecoder().decode([Achievement].self, from: data)
        } catch {
            print("Failed to load achievements: \(error)")
            return nil
        }
    }
}

import Foundation

extension UserDefaultsManager {
    func updateLastVisitDate() {
        let calendar = Calendar.current
        let today = Date()
        let defaults = UserDefaults.standard

        if let lastVisit = defaults.object(forKey: lastVisitDateKey) as? Date,
           let consecutiveDays = defaults.object(forKey: consecutiveDaysKey) as? Int {
            if calendar.isDateInYesterday(lastVisit) {
                defaults.set(consecutiveDays + 1, forKey: consecutiveDaysKey)
            } else if !calendar.isDateInToday(lastVisit) {
                defaults.set(1, forKey: consecutiveDaysKey)
            }
        } else {
            defaults.set(1, forKey: consecutiveDaysKey)
        }

        defaults.set(today, forKey: lastVisitDateKey)
        defaults.synchronize()
    }

    func getConsecutiveDays() -> Int {
        return UserDefaults.standard.integer(forKey: consecutiveDaysKey)
    }
}

extension UserDefaultsManager {
    private var coinKey: String { "coin" }

    func getCoins() -> Int {
        return UserDefaults.standard.integer(forKey: coinKey)
    }

    func addCoins(_ amount: Int) {
        guard amount > 0 else { return }
        let currentCoins = getCoins()
        let newTotal = currentCoins + amount
        UserDefaults.standard.set(newTotal, forKey: coinKey)
        UserDefaults.standard.synchronize()
    }

    func setCoins(_ amount: Int) {
        UserDefaults.standard.set(amount, forKey: coinKey)
        UserDefaults.standard.synchronize()
    }
}

extension UserDefaultsManager {
    func resetAllData() {
        let defaults = UserDefaults.standard
        
        defaults.removeObject(forKey: "guest")
        defaults.removeObject(forKey: "name")
        defaults.removeObject(forKey: "isLoggedIn")
        defaults.removeObject(forKey: "savedVolcanoes")
        defaults.removeObject(forKey: "savedAchievements")
        defaults.removeObject(forKey: "lastVisitDate")
        defaults.removeObject(forKey: "consecutiveDays")
        defaults.removeObject(forKey: "coin")
        defaults.removeObject(forKey: "exploredCount")
        defaults.removeObject(forKey: "gameScores")
        
        defaults.synchronize()
    }
}
