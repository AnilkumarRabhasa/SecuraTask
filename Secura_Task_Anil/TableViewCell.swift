//
//  TableViewCell.swift
//  Secura_Task_Anil
//
//  Created by anil on 23/02/17.
//  Copyright © 2017 anil. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var qrBarcodeLabel : UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
