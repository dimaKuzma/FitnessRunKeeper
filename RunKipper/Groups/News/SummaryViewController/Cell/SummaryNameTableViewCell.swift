//
//  NameTableViewCell.swift
//  RunKipper
//
//  Created by Дмитрий on 2/12/21.
//  Copyright © 2021 DK. All rights reserved.
//

import UIKit

class SummaryNameTableViewCell: UITableViewCell {
    // - UI
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var fullDateLabel: UILabel!
    @IBOutlet weak var shortDateLabel: UILabel!
    @IBOutlet weak var routeImage: UIImageView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var caloryLabel: UILabel!
    
    // - Cache
    var cache: SnapshotterCache!
    
    // - Data
    var routesArray = [CLLocation]()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
// MARK: -
// MARK: Configure
extension SummaryNameTableViewCell {
    func configureAvatar() {
        if let imageData = UserDefaults.standard.object(forKey: "avatarImage") as? Data {
            let avatar = UIImage(data: imageData)!
            avatarImage.image = avatar
            
        }
    }
    
    func configureCache() {
        cache = SnapshotterCache()
    }
    
    func configureLabels(newsProfile: NewsProfile) {
        fullDateLabel.text = newsProfile.fullDate
        shortDateLabel.text = newsProfile.shortDate
        distanceLabel.text = "\(newsProfile.distance) км"
        timeLabel.text = newsProfile.time
        tempLabel.text = newsProfile.temp
        caloryLabel.text = "\(newsProfile.calory)"
    }
    
    func configureRouteImage(newsProfile: NewsProfile) {
        for profileRoute in newsProfile.route {
            let route = CLLocation(latitude: profileRoute.latitude, longitude: profileRoute.longitude)
            routesArray.append(route)
        }
        cache.getMapShaphsotAtWorkout(routes: routesArray) { (snapshot) in
            self.routeImage.image = snapshot
        }
    }
}
