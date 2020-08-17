
import UIKit
import FirebaseAuth
import FirebaseFirestore

class MainUserViewController : UIViewController {
    
    @IBOutlet weak var helloUserLabel: UILabel!
    @IBOutlet weak var favoriteArtistsTable: UITableView!
    @IBOutlet weak var searchNearbyButton: UIButton!
    @IBOutlet weak var findArtistsButton: UIButton!
    @IBOutlet weak var myArtistsTV: UITableView!
    
    let db = Firestore.firestore()
    
    var myArtists: [ArtistData] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchNearbyButton.layer.cornerRadius =
            searchNearbyButton.frame.size.height / 5
        
        findArtistsButton.layer.cornerRadius =
        findArtistsButton.frame.size.height / 5
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        myArtistsTV.register(UINib(nibName: "ArtistItemView", bundle: nil), forCellReuseIdentifier: "ArtistItemViewCell")
    }
    
}

// MARK: - UITableViewDataSource
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
