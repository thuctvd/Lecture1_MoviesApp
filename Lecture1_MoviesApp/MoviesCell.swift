//
//  MoviesCell.swift
//  Lecture1_MoviesApp
//
//  Created by Truong Vo Duy Thuc on 10/11/16.
//  Copyright © 2016 thuctvd. All rights reserved.
//

import UIKit

class MoviesCell: UITableViewCell {
  @IBOutlet weak var avatarImg: UIImageView!
  @IBOutlet weak var overViewLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
