import Foundation

class OAuth2TokenStorage {
    private let userDefaults = UserDefaults.standard
    private enum Keys: String {
        case token
    }
    
    var token: String? {
        get {
            guard let data = userDefaults.data(forKey: Keys.token.rawValue),
                  let token = try? JSONDecoder().decode(String.self, from: data) else {
                return nil
            }
            return token
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить токен")
                return
            }
            userDefaults.set(data, forKey: Keys.token.rawValue)
            print("token.rawValue =",data)
        }
    }
}
