import SwiftUI

@main
struct VulcanApp: App {
    let userDefaults = UserDefaultsManager()
    var body: some Scene {
        WindowGroup {
            if userDefaults.checkLogin() {
                MainView()
                    .onAppear() {
                        UserDefaultsManager.shared.updateLastVisitDate()
                    }
            } else {
                RegistationView()
                    .onAppear() {
                        UserDefaultsManager.shared.updateLastVisitDate()
                        userDefaults.quitQuest()
                    }
            }
        }
    }
}
