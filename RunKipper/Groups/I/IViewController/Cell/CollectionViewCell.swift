//
//  CollectionViewCell.swift
//  RunKipper
//
//  Created by Дмитрий on 1/11/21.
//  Copyright © 2021 DK. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    // - Images
    @IBOutlet weak var firstImage: UIImageView!
    @IBOutlet weak var secondImage: UIImageView!
    @IBOutlet weak var thirdImage: UIImageView!
    // - Labels
    @IBOutlet weak var firstDiscriptionLabel: UILabel!
    @IBOutlet weak var secondDiscriptionLabel: UILabel!
    @IBOutlet weak var thirdDiscriptionLabel: UILabel!
    @IBOutlet weak var kmLabel: UILabel!
    @IBOutlet weak var mpkmLabel: UILabel!
    @IBOutlet weak var thisTimeDistanceLabel: UILabel!
    @IBOutlet weak var thisTimeTempLabel: UILabel!
    @IBOutlet weak var thisTimeWorkoutsLabel: UILabel!
    @IBOutlet weak var lastTimeDistanceLabel: UILabel!
    @IBOutlet weak var lastTimeTempLabel: UILabel!
    @IBOutlet weak var lastTimeWorkoutsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
