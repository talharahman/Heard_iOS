
import UIKit

class MainUserViewController : UIViewController {
    
    @IBOutlet weak var helloUserLabel: UILabel!
    @IBOutlet weak var favoriteArtistsTable: UITableView!
    @IBOutlet weak var searchNearbyButton: UIButton!
    @IBOutlet weak var findArtistsButton: UIButton!
    @IBOutlet weak var myArtistsTV: UITableView!
    
    let firebase = FirebaseRepository()
    var myArtists: [ArtistData] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  firebase.delegate = self
        myArtistsTV.register(UINib(nibName: "ArtistItemView", bundle: nil), forCellReuseIdentifier: "ArtistItemViewCell")
        loadMyFollowedArtists()
    }
    
    func loadMyFollowedArtists() {
        
    }
    
}

//// MARK: - UITableViewDataSource
//extension MainUserViewController : UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return myArtists.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//    }
//
//}

//// MARK: - FetchArtistDelegate
//extension MainUserViewController : FetchArtistDelegate {
//
//    func myArtistsReceived(_ myArtists: [ArtistData]) {
//        <#code#>
//    }
//
//    func onError(_ error: Error) {
//        <#code#>
//    }
//}
