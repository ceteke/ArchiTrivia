//
//  FriendsTableViewCell.swift
//  
//
//  Created by Cem Eteke on 7/2/15.
//
//

import UIKit

class FriendsTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var friendRank: UILabel!
    @IBOutlet weak var friendProfilePicture: UIImageView!
}
