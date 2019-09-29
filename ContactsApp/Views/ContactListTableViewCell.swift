//
//  ContactListTableViewCell.swift
//  ContactsApp
//
//  Created by Aman Agarwal on 29/09/19.
//  Copyright © 2019 Aman Agarwal. All rights reserved.
//

import UIKit

class ContactListTableViewCell: UITableViewCell {
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var acountNameLabel: UILabel!
    @IBOutlet weak var favouriteImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.profilePicImageView.layer.cornerRadius = self.profilePicImageView.frame.size.height/2
        self.profilePicImageView.layer.masksToBounds = false
        self.profilePicImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
