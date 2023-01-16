import Foundation

//enum Constants {
//    static let accessKey = "sMwlgEfPs_JTrR4USTHssO46g2w52m6z-vRdBTuIvKs"
//    static let secretKey = "mQ0gz9mOQyspkUZFVqRclvy9XWJMVx2sEKtoFL11tW8"
//    static let redirectUri = "urn:ietf:wg:oauth:2.0:oob"
//    static let accessScope = "public+read_user+write_likes"
//    static let defaultBaseUrl = URL(string: "https://api.unsplash.com")!
//    static let unsplashAuthString = "https://unsplash.com/oauth/authorize"
//    static let oauthString = "https://unsplash.com/oauth/token"
//    static let tokenKey = "Auth token"
//    static let getPhotosUrlString = "https://api.unsplash.com/photos"
//}

let AccessKey = "sMwlgEfPs_JTrR4USTHssO46g2w52m6z-vRdBTuIvKs"
let SecretKey = "mQ0gz9mOQyspkUZFVqRclvy9XWJMVx2sEKtoFL11tW8"
let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
let AccessScope = "public+read_user+write_likes"

let DefaultBaseURL = URL(string: "https://api.unsplash.com")!
let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

let OauthString = "https://unsplash.com/oauth/token"
let TokenKey = "Auth token"
let GetPhotosUrlString = "https://api.unsplash.com/photos"

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    let oauthString: String
    let tokenKey: String
    let getPhotosUrlString: String
    
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL , oauthString: String, tokenKey: String , getPhotosUrlString: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
        
        self.oauthString = oauthString
        self.tokenKey = tokenKey
        self.getPhotosUrlString = getPhotosUrlString
    }
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: AccessKey,
                                 secretKey: SecretKey,
                                 redirectURI: RedirectURI,
                                 accessScope: AccessScope,
                                 authURLString: UnsplashAuthorizeURLString,
                                 defaultBaseURL: DefaultBaseURL,
                                 oauthString: OauthString,
                                 tokenKey: TokenKey,
                                 getPhotosUrlString: GetPhotosUrlString
        )
    }
}
