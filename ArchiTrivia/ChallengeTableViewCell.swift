//
//  ChallengeTableViewCell.swift
//  ArchiTrivia
//
//  Created by Cem Eteke on 7/17/15.
//  Copyright (c) 2015 Cem Eteke. All rights reserved.
//

import UIKit

class ChallengeTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var challenged_point: UILabel!
    @IBOutlet weak var challenger_point: UILabel!
    @IBOutlet weak var challenger_name: UILabel!
    @IBOutlet weak var challenged_name: UILabel!
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
