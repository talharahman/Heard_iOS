import Foundation

// MARK: - API WRAPPER
struct ResultsBase : Codable {
    
    var results: [ArtistData]
       
}

// MARK: - ITUNES API OBJECT
struct ArtistData : Codable {
    
    let artistName: String
    let artworkUrl100: String
    
    init(_ artistName: String, _ artworkUrl100: String) {
        self.artistName = artistName
        self.artworkUrl100 = artworkUrl100
    }
}



