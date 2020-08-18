
import UIKit
import FirebaseAuth
import FirebaseFirestore

class AddArtistViewController : UIViewController {
    
    @IBOutlet weak var artistView: UIView!
    @IBOutlet weak var artistImage: UIImageView!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var addArtistButton: UIButton!
    @IBOutlet weak var searchArtistField: UITextField!
    
    var searchManager = ArtistSearchManager()
    var selectedArtist: ArtistData?
    let firebase = FirebaseRepository()
//    let db = Firestore.firestore()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addArtistButton.layer.borderWidth = 1
        addArtistButton.layer.borderColor = UIColor.black.cgColor
        addArtistButton.layer.cornerRadius =
             addArtistButton.frame.size.height / 5
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchArtistField.delegate = self
        searchManager.delegate = self
        artistView.isHidden = true
    }
    
    
    @IBAction func addArtistPressed(_ sender: UIButton) {
        if let safeData = selectedArtist {
            firebase.updateFollowedArtists(with: safeData)
            
            
            
//        if let name = selectedArtist?.artistName,
//           let image = selectedArtist?.artworkUrl100,
//            let userID = Auth.auth().currentUser?.uid {
//            db.collection("profiles")
//                .addDocument(data:
//                    ["userID": userID,
//                     "followedArtists": name]) {
//                        (error) in
//                        if let e = error {
//                        print("There was an issue saving data to firestore, \(e)")
//                        } else {
//                        print("Successfully saved data")
//                        }
//            }
        }
    }

}

// MARK: - UITextFieldDelegate
extension AddArtistViewController : UITextFieldDelegate {
    
    @IBAction func searchArtistPressed(_ sender: UIButton) {
        searchArtistField.endEditing(true)
        print(searchArtistField.text!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchArtistField.endEditing(true)
        print(searchArtistField.text!)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type artist name"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let input = searchArtistField.text {
            selectedArtist = nil
            searchManager.fetchArtist(with: input)
        }
        searchArtistField.text = ""
    }
}

// MARK: - ArtistSearchManagerDelegate
extension AddArtistViewController : ArtistSearchDelegate {
    
    func onSuccess(_ artistSearchManager: ArtistSearchManager, _ artist: ArtistData) {
        DispatchQueue.main.async {
            self.artistView.isHidden = false
            self.artistName.text = artist.artistName
            self.artistImage.load(urlString: artist.artworkUrl100)
            self.selectedArtist = artist
        }
    }
    
    func onError(_ error: Error) {
        print(error)
    }
    
}

// MARK: - ImageView URL conversion
extension UIImageView {
    func load(urlString: String) {
        let url = URL(string: urlString)
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url!) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
