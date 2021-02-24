//
//  RunCollectionViewCell.swift
//  RunKipper
//
//  Created by Дмитрий on 2/1/21.
//  Copyright © 2021 DK. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class RunCollectionViewCell: UICollectionViewCell {
    // - UI
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var averageTempLabel: UILabel!
    @IBOutlet weak var discriptionTimeLabel: UILabel!
    @IBOutlet weak var discriptionDistanceLabel: UILabel!
    @IBOutlet weak var discriptionCurrentTempLabel: UILabel!
    @IBOutlet weak var discriptionAverageTempLabel: UILabel!

    // - Delegate
    weak var runVC: RunViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

