
import UIKit

class AddArtistViewController : UIViewController {
    
    
    @IBOutlet weak var artistImage: UIImageView!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var addArtistButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addArtistButton.layer.cornerRadius =
        addArtistButton.frame.size.height / 5
        addArtistButton.layer.borderWidth = 1
        addArtistButton.layer.borderColor = UIColor.black.cgColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addArtistPressed(_ sender: UIButton) {
    }
}
