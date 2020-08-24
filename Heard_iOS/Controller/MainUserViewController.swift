
import UIKit

class MainUserViewController : UIViewController {

    @IBOutlet weak var helloUserLabel: UILabel!
    @IBOutlet weak var favoriteArtistsTable: UITableView!
    @IBOutlet weak var myArtistsTV: UITableView!
    
    let firebase = FirebaseRepository()
    var myArtists: [ArtistData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firebase.fetchUser = self
        myArtistsTV.register(UINib(nibName: "ArtistItemView", bundle: nil), forCellReuseIdentifier: "ArtistItemViewCell")
        loadMyFollowedArtists()
    }
    
    func loadMyFollowedArtists() {
        
    }
    
}

// MARK: - Fetch User Delegate
extension MainUserViewController : FetchUserDelegate {
    func onUserReceived(_ userData: UserData) {
        helloUserLabel.text = "Hello \(userData.user_name!)"
    }
    
    func onError(_ error: Error) {
        print(error.localizedDescription)
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
