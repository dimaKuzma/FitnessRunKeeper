//
//  MapCollectionViewCell.swift
//  RunKipper
//
//  Created by Дмитрий on 2/6/21.
//  Copyright © 2021 DK. All rights reserved.
//

import UIKit

class MapCollectionViewCell: UICollectionViewCell {
    // - UI
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var nextCollectionViewCell: UIButton!
    
    // - Delegate
    weak var delegate: RunCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    @IBAction func nextCollectionViewCell(_ sender: Any) {
        delegate?.didTapNextButton()
    }
}

// MARK: -
// MARK: Configure()
extension MapCollectionViewCell {
    func configure() {
        configureMapView()
    }
    
    
    func configureMapView() {
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
}
