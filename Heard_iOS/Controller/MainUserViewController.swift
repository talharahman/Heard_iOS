
import UIKit

class MainUserViewController : UIViewController {
    
    @IBOutlet weak var helloUserLabel: UILabel!
    @IBOutlet weak var favoriteArtistsTable: UITableView!
    @IBOutlet weak var searchNearbyButton: UIButton!
    @IBOutlet weak var findArtistsButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchNearbyButton.layer.cornerRadius =
            searchNearbyButton.frame.size.height / 5
        
        findArtistsButton.layer.cornerRadius =
        findArtistsButton.frame.size.height / 5
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
}
