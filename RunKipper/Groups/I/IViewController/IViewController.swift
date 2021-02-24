//
//  IViewController.swift
//  RunKipper
//
//  Created by Дмитрий on 12/18/20.
//  Copyright © 2020 DK. All rights reserved.
//

import UIKit
import RealmSwift

class IViewController: UIViewController {
    // - UI
    @IBOutlet weak var kilometresLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewUnderScroll: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var achievementsView: UIView!
    @IBOutlet weak var workoutsTableView: UITableView!
    @IBOutlet weak var workoutsButton: UIButton!
    @IBOutlet weak var achievementContinueImage: UIImageView!
    @IBOutlet weak var achievementFiveKImage: UIImageView!
    @IBOutlet weak var achievementTenKImage: UIImageView!
    @IBOutlet weak var achievementHalfMarathonImage: UIImageView!
    @IBOutlet weak var achievementMarathonImage: UIImageView!
    
    
    // - ImagePicker
    let imagePicker = UIImagePickerController()
    
    // - Realm
    let realm = try! Realm()
    
    // - Data
    var newsProfile = [NewsProfile]()
    var distance = 0
    var calory = 0
    var timeInSeconds = 0
    var timeString = ""
    var averageTemp = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configure()
    }
    
    @IBAction func workoutsButtonAction(_ sender: Any) {
        let workoutsVC = UIStoryboard(name: "Workout", bundle: nil).instantiateInitialViewController() as! WorkoutViewController
        workoutsVC.iVC = self
        workoutsVC.modalPresentationStyle = .overFullScreen
        navigationController?.pushViewController(workoutsVC, animated: true)
    }
    
    @IBAction func avatarButtonAction(_ sender: Any) {
        showAllert()
    }
    
    @IBAction func aimsButtonAction(_ sender: Any) {
        let aimsVC = UIStoryboard(name: "Aims", bundle: nil).instantiateInitialViewController() as! AimsViewController
        aimsVC.modalPresentationStyle = .overFullScreen
        navigationController?.pushViewController(aimsVC, animated: true)
    }
    
    func showAllert() {
        let alertController = UIAlertController(title: "Выбрать фото для профиля", message: nil, preferredStyle: .alert)
        present(alertController, animated: true, completion: nil)
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { (alert) in
            //
        }
        let cameraAction = UIAlertAction(title:"Камера", style: .default) { (alert ) in
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .camera
            self.imagePicker.modalPresentationStyle = .fullScreen
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        let galeryAction = UIAlertAction(title: "Фотогалерея", style: .default) { (alert) in
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.modalPresentationStyle = .fullScreen
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        alertController.addAction(cameraAction)
        alertController.addAction(galeryAction)
        alertController.addAction(cancelAction)
    }
}

// MARK: -
// MARK: Configure
extension IViewController {
    func configure() {
        configureCountOfWorkouts()
        configureScrollView()
        configureAvatar()
        configureCollectionView()
        configureAchievements()
        configureAchievementsViewTap()
        configureWorkoutsTableView()
        configureNavigationController()
    }
    
    func configureAchievements() {
        var theLongestWorkoutDistance = 0.0
        if newsProfile.count == 0 {
            achievementContinueImage.image = UIImage(named: "continueningNone")
            achievementFiveKImage.image = UIImage(named: "10kNone")
            achievementTenKImage.image = UIImage(named: "21kNone")
            achievementHalfMarathonImage.image = UIImage(named: "42kNone")
            achievementMarathonImage.image = UIImage(named: "42kNone")
        } else {
            for new in newsProfile {
                if new.distance > theLongestWorkoutDistance {
                    theLongestWorkoutDistance = new.distance
                    achievementContinueImage.image = UIImage(named: "continuening")
                }
            }
            for new in newsProfile {
                if new.distance >= 42.0 {
                    achievementMarathonImage.image = UIImage(named: "42k")
                }else if new.distance >= 21.0 {
                    achievementHalfMarathonImage.image = UIImage(named: "21k")
                }else if new.distance >= 10.0 {
                    achievementTenKImage.image = UIImage(named: "10k")
                }else if new.distance >= 5.0 {
                    achievementFiveKImage.image = UIImage(named: "5k")
                }
            }
        }
    }
    
    func configureTime(time: Int) -> String {
        if time < 3600 {
            let minutes = time / 60
            let seconds = time % 60
            let secondsString = seconds > 9 ?"\(seconds)" : "0\(seconds)"
            let minutesString = minutes > 9 ?"\(minutes)" : "0\(minutes)"
            return minutesString + ":" + secondsString
        } else {
            let hours = time / 3600
            let minutes = (time % 3600) / 60
            let seconds = (time % 3600) % 60
            let hoursString = hours > 9 ?"\(hours)" : "0\(hours)"
            let secondsString = seconds > 9 ?"\(seconds)" : "0\(seconds)"
            let minutesString = minutes > 9 ?"\(minutes)" : "0\(minutes)"
            return hoursString + ":" + minutesString + ":" + secondsString
        }
    }
    
    func configureCountOfWorkouts() {
        newsProfile = Array(realm.objects(NewsProfile.self))
        workoutsButton.setTitle("\(newsProfile.count)", for: .normal)
        distance = 0
        for new in newsProfile {
            distance += Int(new.distance)
        }
        kilometresLabel.text = "\(distance)"
        var timeSeconds = 0
        for new in newsProfile {
            calory += new.calory
            timeSeconds += new.timeInSeconds
        }
        timeString = configureTime(time: timeSeconds)
        if distance == 0 {
            averageTemp = "00:00"
        } else {
        let temp = timeSeconds / distance
        averageTemp = configureTime(time: temp)
        workoutsTableView.reloadData()
        }
    }
    
    func configureWorkoutsTableView(){
        workoutsTableView.delegate = self
        workoutsTableView.dataSource = self
    }
    
    func configureAvatar() {
        if let imageData = UserDefaults.standard.object(forKey: "avatarImage") as? Data {
            let avatar = UIImage(data: imageData)!
            avatarButton.setImage(avatar, for: .normal)
            avatarButton.clipsToBounds = true
        } else {
            avatarButton.setImage(UIImage(named: "camera"), for: .normal)
        }
        if let name = UserDefaults.standard.object(forKey: "Name") {
            nameLabel.text = "\(name)"
        }
    }
    
    func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func configureScrollView() {
        scrollView.frame.size = UIScreen.main.bounds.size
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: 1000)
        viewUnderScroll.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: scrollView.contentSize.height)
    }
    
    func configureNavigationController() {
        let backButton = UIBarButtonItem()
        navigationItem.backBarButtonItem = backButton
        navigationItem.backBarButtonItem?.tintColor = .white
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    func configureAchievementsViewTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        achievementsView.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let achievementsVC = UIStoryboard(name: "Achievements", bundle: nil).instantiateInitialViewController() as! AchievementsViewController
        achievementsVC.modalPresentationStyle = .overFullScreen
        navigationController?.pushViewController(achievementsVC, animated: true)
    }
}

// MARK: -
// MARK: ImagePickerDelegate
extension IViewController: UIImagePickerControllerDelegate,  UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            UserDefaults.standard.set(image.pngData(), forKey: "avatarImage")
            configureAvatar()
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        avatarButton.setImage(UIImage(named: "camera"), for: .normal)
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: -
// MARK: DataSource CollectionView
extension IViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        if indexPath.item == 0 {
            cell.firstImage.image = UIImage(named: "distance")
            cell.firstDiscriptionLabel.text = "Дистанция"
            cell.kmLabel.text = "(км)"
            cell.secondImage.image = UIImage(named: "average pace")
            cell.secondDiscriptionLabel.text = "Сред.темп"
            cell.mpkmLabel.text = "(мин/км)"
            cell.thirdImage.image = UIImage(named: "count")
            cell.thirdDiscriptionLabel.text = "Тренировки"
            cell.thisTimeTempLabel.text = newsProfile.first?.temp ?? "00:00"
            cell.thisTimeDistanceLabel.text = "\(Int(newsProfile.first?.distance ?? 0))"
            if newsProfile.count == 0 {
              cell.thisTimeWorkoutsLabel.text = "0"
            } else {
              cell.thisTimeWorkoutsLabel.text = "1"
            }
            cell.lastTimeTempLabel.text = averageTemp
            cell.lastTimeDistanceLabel.text = "\(distance)"
            cell.lastTimeWorkoutsLabel.text = "\(newsProfile.count)"
            return cell
        } else {
            cell.firstImage.image = UIImage(named: "calory")
            cell.firstDiscriptionLabel.text = "Расход калорий"
            cell.secondImage.image = UIImage(named: "timer")
            cell.secondDiscriptionLabel.text = "Общее время"
            cell.thirdImage.removeFromSuperview()
            cell.thirdDiscriptionLabel.removeFromSuperview()
            cell.kmLabel.text = ""
            cell.mpkmLabel.text = ""
            cell.thisTimeDistanceLabel.text = "\(newsProfile.first?.calory ?? 0)"
            cell.thisTimeTempLabel.text = newsProfile.first?.time ?? "00:00"
            cell.lastTimeDistanceLabel.text = "\(calory)"
            cell.lastTimeTempLabel.text = timeString
            cell.thisTimeWorkoutsLabel.text = ""
            cell.lastTimeWorkoutsLabel.text = ""
            return cell
        }
    }
}

// MARK: -
// MARK: Delegate CollectionView
extension IViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentIndex = Int(collectionView.contentOffset.x / collectionView.frame.size.width)
        pageControl.currentPage = currentIndex
    }
}

// MARK: -
// MARK: DataSource WorkoutTableView
extension IViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutsTableViewCell", for: indexPath) as! WorkoutsTableViewCell
        cell.countOfWorkoutsLabel.text = "\(newsProfile.count)"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

// MARK: -
// MARK: Delegate WorkoutTableView
extension IViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let workoutVC = UIStoryboard(name: "Workout", bundle: nil).instantiateInitialViewController() as! WorkoutViewController
        workoutVC.modalPresentationStyle = .overFullScreen
        navigationController?.pushViewController(workoutVC, animated: true)
        workoutVC.iVC = self
    }
}

