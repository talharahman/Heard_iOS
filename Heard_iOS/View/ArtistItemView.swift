//
//  ArtistItemView.swift
//  Heard_iOS
//
//  Created by Talha Rahman on 8/16/20.
//  Copyright © 2020 Talha Rahman. All rights reserved.
//

import UIKit

class ArtistItemView: UITableViewCell {

    @IBOutlet weak var artistImage: UIImageView!
    @IBOutlet weak var artistName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
