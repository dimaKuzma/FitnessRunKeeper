//
//  DetailTableViewCell.swift
//  RunKipper
//
//  Created by Дмитрий on 2/12/21.
//  Copyright © 2021 DK. All rights reserved.
//

import UIKit

class SummaryDetailTableViewCell: UITableViewCell {
    // - UI
    @IBOutlet weak var discriptionImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    
    // - Constraint
    @IBOutlet weak var nameLabelCenterConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
}
