//
//  MenuViewController.swift
//  Networking
//
//  Created by Roma Bogatchuk on 17.11.2022.
//

import UIKit
import UserNotifications

class MenuViewController: UICollectionViewController {

    private let menuSections = MenuSections.allCases
    private let url = "https://jsonplaceholder.typicode.com/posts"
    
    private var alert: UIAlertController!
    private var dataProvider = DataProvider()
    private var filePath: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForNotification()
        
        dataProvider.fileLocation = {location in
            //Сохранение файла для дальнейшего использования
            print("Download finished: \(location.absoluteString)")
            self.filePath = location.absoluteString
            self.alert.dismiss(animated: false)
            self.postNotification()
        }
    }
    
    func showAler(){
        alert = UIAlertController(title: "Download...", message: "0%", preferredStyle: .alert)
        
        let height = NSLayoutConstraint(item: alert.view!,
                                        attribute: .height,
                                        relatedBy: .equal,
                                        toItem: nil,
                                        attribute: .notAnAttribute,
                                        multiplier: 0,
                                        constant: 170)
        alert.view.addConstraint(height)
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive){_ in 
            self.dataProvider.stopDownload()
        }
        alert.addAction(cancel)
        
        present(alert, animated: true){
            
            let size = CGSize(width: 40, height: 40)
            let point = CGPoint(x: self.alert.view.frame.width / 2 - size.width / 2,
                                y: self.alert.view.frame.height / 2 - size.height / 2)
            
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(origin: point, size: size))
            activityIndicator.color = .gray
            activityIndicator.startAnimating()
            
            let progressView = UIProgressView(frame: CGRect(x: 0,
                                                            y: self.alert.view.frame.height - 44,
                                                            width: self.alert.view.frame.width,
                                                            height: 2))
            progressView.tintColor = .blue
            self.dataProvider.onProgress = { progress in
                progressView.progress = Float(progress)
                self.alert.message = String(Int(progress * 100)) + "%"
            }
            
            
            self.alert.view.addSubview(activityIndicator)
            self.alert.view.addSubview(progressView)
            
            
        }
    }
    
    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuSections.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MenuCell
        let menuSection = menuSections[indexPath.item]
        cell.label.text = menuSection.rawValue
        cell.layer.cornerRadius = 10
    
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectMenuItem = menuSections[indexPath.item]
        
        switch selectMenuItem {
        case .downloadImage:
            performSegue(withIdentifier: "downloadImage", sender: self)
        case.getRequest:
            NetworkManager.shared.getRequest(url: url)
        case .postRequest:
            NetworkManager.shared.postRequest(url: url)
        case .coursesSwiftbook:
            performSegue(withIdentifier: "courses", sender: self)
        case .uploadImage:
            NetworkManager.shared.uploadImage(url: "https://api.imgur.com/3/image")
        case .downloadFile:
            showAler()
            dataProvider.startDownload()
            print("dwnload")
        }
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using [segue destinationViewController].
         // Pass the selected object to the new view controller.
         }
         */
    }

}
// MARK: UICollectionViewDelegateFlowLayout

extension MenuViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 48, height: 100)
    }
}

// MARK: UserNotifications

extension MenuViewController {
    //Запрос на разрешение отправки пушей
    private func registerForNotification(){
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in

        }
    }
    
    private func postNotification(){
        let content = UNMutableNotificationContent()
        content.title = "Download complate!"
        content.body = "Your background transfer has complate. File path: \(filePath!)"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let request = UNNotificationRequest(identifier: "TransferComplate", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}
