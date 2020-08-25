
import UIKit

class MainUserViewController : UIViewController {

    @IBOutlet weak var helloUserLabel: UILabel!
    @IBOutlet weak var myArtistsTV: UITableView!
    
    let firebase = FirebaseRepository()
    var myArtists: [ArtistData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firebase.fetchArtists = self
        firebase.fetchUser = self
        
        myArtistsTV.dataSource = self
        myArtistsTV.register(UINib(nibName: "ArtistItemView", bundle: nil), forCellReuseIdentifier: C.myArtists)
        
        loadMyFollowedArtists()
    }
    
    func loadMyFollowedArtists() {
        firebase.fetchFollowedArtists()
//
//
//        firebase
//            .artists
//            .whereField(C.artistFollowers, arrayContains: firebase.auth.currentUser?.email! as Any)
//            .getDocuments() { (querySnapshot, err) in
//
//                self.myArtists = []
//                if let err = err {
//                    print("Error getting documents: \(err)")
//                } else {
//                    for document in querySnapshot!.documents {
//                    let data = document.data()
//                    if let name = data[C.artistName] as? String,
//                        let image = data[C.artistImage] as? String {
//
//                        let newArtist = ArtistData(name, image)
//                        self.myArtists.append(newArtist)
//
//                        print(self.myArtists.count)
//
//                        DispatchQueue.main.async {
//                            self.myArtistsTV.reloadData()
//                        }
//
//                    }
//                }
//            }
//        }
    }
    
}

// MARK: - Fetch User Delegate
extension MainUserViewController : FetchUserDelegate {
    func onUserReceived(_ userData: UserData) {
        helloUserLabel.text = "Hello \(userData.user_name ?? "User")"
    }
}



// MARK: - UITableViewDataSource
extension MainUserViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myArtists.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let artist = myArtists[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: C.myArtists, for: indexPath) as! ArtistItemView
        
        cell.artistName.text = artist.artistName
        cell.artistImage.load(urlString: artist.artworkUrl100)
        
        return cell
    }

}

// MARK: - FetchArtistDelegate
extension MainUserViewController : FetchArtistDelegate {

    func myArtistsReceived(_ myArtists: [ArtistData]) {
        DispatchQueue.main.async {
            self.myArtists = myArtists
            self.myArtistsTV.reloadData()
            let indexPath = IndexPath(row: self.myArtists.count - 1, section: 0)
            self.myArtistsTV.scrollToRow(at: indexPath, at: .top, animated: true)
//
//            self.myArtistsTV.scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.bottom, animated: true)
        }
    }
}
