import Foundation
import SwiftKeychainWrapper

protocol OAuth2TokenStoring {
    var token: String? { get set }
}
class OAuth2TokenStorage: OAuth2TokenStoring {
    
    var token: String? {
        get {
            let token: String? = KeychainWrapper.standard.string(forKey: "Auth token")
            return token
        }
        set {
            if let newValue = newValue {
                KeychainWrapper.standard.set(newValue, forKey: "Auth token")
            } else {
                KeychainWrapper.standard.removeObject(forKey: "Auth token")
            }
        }
    }
}
