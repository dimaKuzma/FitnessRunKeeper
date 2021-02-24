//
//  NewsCollectionViewCell.swift
//  RunKipper
//
//  Created by Дмитрий on 2/5/21.
//  Copyright © 2021 DK. All rights reserved.
//

import UIKit

class NewsCollectionViewCell: UICollectionViewCell {
    // - UI
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var fullDateLabel: UILabel!
    @IBOutlet weak var shortDateLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var routeImage: UIImageView!
    
    // - SnapshotCache
    var cache: SnapshotterCache!
    
    // - Data
    var routesArray = [CLLocation]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension NewsCollectionViewCell {
    func configureName() {
        if let imageData = UserDefaults.standard.object(forKey: "avatarImage") as? Data {
            let avatar = UIImage(data: imageData)!
            avatarImage.image = avatar
        }
        if let name = UserDefaults.standard.object(forKey: "Name") {
            nameLabel.text = "\(name)"
        }
        
    }
    
    func configure(profile: NewsProfile) {
        fullDateLabel.text = profile.fullDate
        shortDateLabel.text = profile.shortDate
        distanceLabel.text = "\(profile.distance) км"
        tempLabel.text = profile.temp
        timeLabel.text = profile.time
        for profileRoute in profile.route {
            let route = CLLocation(latitude: profileRoute.latitude, longitude: profileRoute.longitude)
            routesArray.append(route)
        }
        configureImage(routes: routesArray)
    }
    
    func configureCache() {
        self.cache = SnapshotterCache()
    }
    
    func configureImage(routes: [CLLocation]) {
        cache.getMapShaphsotAtWorkout(routes: routesArray) { (snapshot) in
            self.routeImage.image = snapshot
        }
    }
}
