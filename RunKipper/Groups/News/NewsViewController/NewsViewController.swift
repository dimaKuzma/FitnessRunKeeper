//
//  WorkoutsViewController.swift
//  RunKipper
//
//  Created by Дмитрий on 12/18/20.
//  Copyright © 2020 DK. All rights reserved.
//

import UIKit
import RealmSwift

class NewsViewController: UIViewController {
    // - UI
    @IBOutlet weak var collectionView: UICollectionView!
    
    // - Data
    var newsProfile = [NewsProfile]()
    
    // - Realm
    let realm = try! Realm()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configure()
        collectionView.reloadData()
    }
    
}

// MARK: -
// MARK: Configure
extension NewsViewController {
    func configure() {
        configureRealm()
        configureCollectionView()
        configureNavigationController()
    }
    
    func configureRealm() {
        newsProfile = Array(realm.objects(NewsProfile.self))
    }
    
    func configureCollectionView() {
        collectionView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func configureNavigationController() {
        let backButton = UIBarButtonItem()
        navigationItem.backBarButtonItem = backButton
        navigationItem.backBarButtonItem?.tintColor = .white
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
}

// MARK: -
// MARK: CollectionView dataSource
extension NewsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsProfile.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsCollectionViewCell", for: indexPath) as! NewsCollectionViewCell
        cell.configureCache()
        cell.configureName()
        cell.configure(profile: newsProfile[indexPath.row])
        if newsProfile[indexPath.row].route.count == 0 {
            cell.routeImage.isHidden = true
        } else {
            cell.routeImage.isHidden = false
        }
        return cell
    }
    
    
}

// MARK: -
// MARK: CollectionView Delegate
extension NewsViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: collectionView.frame.width, height: 170)
        let sizeWithImage = CGSize(width: collectionView.frame.width, height: 350)
        if newsProfile[indexPath.row].route.count == 0 {
            return size
        } else {
            return sizeWithImage
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let summaryVC = UIStoryboard(name: "Summary", bundle: nil).instantiateInitialViewController() as! SummaryViewController
        summaryVC.newsVC = self
        summaryVC.newsProfile = newsProfile[indexPath.row]
        navigationController?.pushViewController(summaryVC, animated: true)
    }
}
