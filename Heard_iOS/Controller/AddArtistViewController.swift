
import UIKit

class AddArtistViewController : UIViewController {
    
    @IBOutlet weak var artistImage: UIImageView!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var addArtistButton: UIButton!
    @IBOutlet weak var searchArtistField: UITextField!
    
    var searchManager = ArtistSearchManager()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addArtistButton.layer.cornerRadius =
        addArtistButton.frame.size.height / 5
        addArtistButton.layer.borderWidth = 1
        addArtistButton.layer.borderColor = UIColor.black.cgColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchArtistField.delegate = self
        searchManager.delegate = self
    }
    
    
    @IBAction func addArtistPressed(_ sender: UIButton) {
        
    }

}

// MARK: - UITextFieldDelegate
extension AddArtistViewController : UITextFieldDelegate {
    
    @IBAction func searchArtistPressed(_ sender: UIButton) {
        searchArtistField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchArtistField.endEditing(true)
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
            searchManager.fetchArtist(with: input)
        }
        searchArtistField.text = ""
    }
}

// MARK: - ArtistSearchManagerDelegate
extension AddArtistViewController : ArtistSearchDelegate {
    
    func onSuccess(_ artistSearchManager: ArtistSearchManager, _ artist: ArtistData) {
        DispatchQueue.main.async {
            self.artistName.text = artist.artistName
            self.artistImage.load(urlString: artist.artworkUrl100)
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
