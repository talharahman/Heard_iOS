import Foundation

protocol ArtistSearchDelegate {
    
    func onSuccess(_ artistSearchManager: ArtistSearchManager,
                   _ artist:  ArtistData)
    
    func onError(_ error: Error)
}

struct ArtistSearchManager {
    
    let baseURL = "https://itunes.apple.com"
    
    var delegate: ArtistSearchDelegate?
    
    func fetchArtist(with input: String) {
        let urlString = "\(baseURL)/search?term=\(input)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) {
                (data, response, error) in
                if error != nil {
                    self.delegate?.onError(error!)
                    return
                }
                
                if let safeData = data {
                    if let results = self.parseJSON(safeData) {
                        self.delegate?.onSuccess(self, results)
                    }
                }
                
            }
            task.resume()
        }
    }
    
    func parseJSON(_ artistData: Data) -> ArtistData? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(ResultsBase.self, from: artistData)
            let artistName = decodedData.results[0].artistName
            let artistImage = decodedData.results[0].artworkUrl100
            print(artistImage)
            return ArtistData(artistName, artistImage)
        } catch {
            delegate?.onError(error)
            return nil
        }
    }
    
}
