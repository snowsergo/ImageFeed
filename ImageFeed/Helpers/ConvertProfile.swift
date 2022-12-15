import UIKit

func convert(profile: ProfileResult) -> Profile{
    let obj = Profile(
        username: profile.username,
        name: "\(profile.firstName ?? "") \(profile.lastName ?? "")",
        loginName: "@\(profile.username)" ,
        bio: profile.bio
    )
    return obj
}
