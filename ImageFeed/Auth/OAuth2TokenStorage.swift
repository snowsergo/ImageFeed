import Foundation
import SwiftKeychainWrapper

protocol OAuth2TokenStoring {
    var token: String? { get set }
}
class OAuth2TokenStorage: OAuth2TokenStoring {
    private let keychainWrapper = KeychainWrapper.standard
    
    var token: String? {
        get {
            let token: String? = keychainWrapper.string(forKey: Constants.tokenKey)
            return token
        }
        set {
            if let newValue = newValue {
                keychainWrapper.set(newValue, forKey: Constants.tokenKey)
            } else {
                keychainWrapper.removeObject(forKey: Constants.tokenKey)
            }
        }
    }
}
