//
//  SneakersTableViewCell.swift
//  RunKipper
//
//  Created by Дмитрий on 2/10/21.
//  Copyright © 2021 DK. All rights reserved.
//

import UIKit

class SneakersTableViewCell: UITableViewCell {
    // - UI
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mileageLabel: UILabel!
    @IBOutlet weak var slashLabel: UILabel!
    @IBOutlet weak var termLabel: UILabel!
    @IBOutlet weak var kmLabel: UILabel!
    
    // - Constraint
    @IBOutlet weak var nameLabelCenterConstraint: NSLayoutConstraint!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
