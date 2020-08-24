import Foundation

class UserData {

    var user_name: String?
    var followed_artists: [String]?
    
    init(values: [String : Any]) {
        self.user_name = values[C.userName] as? String ?? nil
        self.followed_artists = values[C.followedArtists] as? [String] ?? nil
    }
}
