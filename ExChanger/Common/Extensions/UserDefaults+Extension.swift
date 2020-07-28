import Foundation

extension UserDefaults {
    
    //MARK: Check Login
    func setLoggedIn(value: Bool) {
        set(value, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
    }

    func isLoggedIn()-> Bool {
        return bool(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
    }
    
    //MARK: User Id
    func setUserId(value: Int) {
        set(value, forKey: UserDefaultsKeys.userId.rawValue)
    }
    
    func userId() -> Int {
        return integer(forKey: UserDefaultsKeys.userId.rawValue)
    }
    
    //MARK: Check Login
    func setFirstTimeLaunch(value: Bool) {
        set(value, forKey: UserDefaultsKeys.isFirstTime.rawValue)
    }

    func isFirstTimeLaunch()-> Bool {
        return bool(forKey: UserDefaultsKeys.isFirstTime.rawValue)
    }
}
