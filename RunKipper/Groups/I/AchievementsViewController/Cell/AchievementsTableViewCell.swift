//
//  AchievementsTableViewCell.swift
//  RunKipper
//
//  Created by Дмитрий on 1/28/21.
//  Copyright © 2021 DK. All rights reserved.
//

import UIKit

class AchievementsTableViewCell: UITableViewCell {
    // - UI
    @IBOutlet weak var continueningImage: UIImageView!
    @IBOutlet weak var fiveKImage: UIImageView!
    @IBOutlet weak var tenKImage: UIImageView!
    @IBOutlet weak var halfMarathonImage: UIImageView!
    @IBOutlet weak var marathonImage: UIImageView!
    @IBOutlet weak var continueningLabel: UILabel!
    @IBOutlet weak var fiveKLabel: UILabel!
    @IBOutlet weak var tenKLabel: UILabel!
    @IBOutlet weak var halfMarathonLabel: UILabel!
    @IBOutlet weak var marathonLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
