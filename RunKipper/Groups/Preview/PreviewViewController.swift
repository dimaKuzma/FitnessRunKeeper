//
//  PreviewViewController.swift
//  RunKipper
//
//  Created by Дмитрий on 2/18/21.
//  Copyright © 2021 DK. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {
    // - UI
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    // - Data
    var currentPage = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        if currentPage != 2 {
            let indexPath = IndexPath(item: currentPage + 1, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        } else {
            let cell = collectionView.cellForItem(at: IndexPath(item: 2, section: 0)) as! PreviewCollectionViewCell
            if cell.textField.text == "" || cell.textField.text == nil {
                showAlert()
            }else if let name = cell.textField.text {
                UserDefaults.standard.set(name, forKey: "Name")
                let tabBar = TabBarController()
                tabBar.modalPresentationStyle = .overFullScreen
                present(tabBar, animated: true, completion: nil)
            }
        }
    }
    
}

// MARK: -
// MARK: Configure
extension PreviewViewController {
    func configure() {
        configureCollectionView()
    }
    
    func configureCollectionView() {
        collectionView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

// MARK: -
// MARK: DataSource CollectionView
extension PreviewViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PreviewCollectionViewCell", for: indexPath) as! PreviewCollectionViewCell
        if indexPath.item == 0 {
            cell.bigLabel.font = UIFont(descriptor: UIFontDescriptor(name: "Bold", size: 38), size: 38)
            cell.bigLabel.text = "Не стой на месте"
            cell.smallLabel.text = "Вступай в общество любителей бега и берись за тренировки всерьез и надолго"
            cell.firstImageView.image = UIImage(named: "firstPicture")
            cell.smallLabel.isHidden = false
            cell.textField.isHidden = true
        } else if indexPath.item == 1 {
            cell.bigLabel.font = UIFont(descriptor: UIFontDescriptor(name: "Bold", size: 38), size: 38)
            cell.bigLabel.text = "Ставь цели"
            cell.smallLabel.text = "... И отслеживай свои спортивные достижения!"
            cell.firstImageView.image = UIImage(named: "secondPicture")
            cell.smallLabel.isHidden = false
            cell.textField.isHidden = true
        } else {
            cell.bigLabel.text = "Введите имя и фамилию"
            cell.bigLabel.font = UIFont(descriptor: UIFontDescriptor(name: "Medium", size: 30), size: 30)
            cell.firstImageView.image = UIImage(named: "thirdPicture")
            cell.smallLabel.isHidden = true
            cell.textField.isHidden = false
        }
        return cell
    }
    
    
}

// MARK: -
// MARK: DataSource CollectionView
extension PreviewViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentIndex = Int(collectionView.contentOffset.x / collectionView.frame.size.width)
        currentPage = currentIndex
        pageControl.currentPage = currentPage
    }
}

// MARK: -
// MARK: Alert
extension PreviewViewController {
    func showAlert() {
        let alertController = UIAlertController(title: "Ошибка", message: "Введите имя", preferredStyle: .alert)
        present(alertController, animated: true, completion: nil)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (alert) in
            print("Ok pressed")
        }
        alertController.addAction(okAction)
    }
}

