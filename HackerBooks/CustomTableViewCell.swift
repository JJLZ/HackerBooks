//
//  CustomTableViewCell.swift
//  HackerBooks
//
//  Created by JJLZ on 2/4/17.
//  Copyright © 2017 ESoft. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    // MARK: IBOutlets
    @IBOutlet weak var ivPhoto: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAuthors: UILabel!
    @IBOutlet weak var lblTags: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
