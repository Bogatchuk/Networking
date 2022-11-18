//
//  MenuViewController.swift
//  Networking
//
//  Created by Roma Bogatchuk on 17.11.2022.
//

import UIKit

class MenuViewController: UICollectionViewController {

    private let menuSections = MenuSections.allCases
    private let url = "https://jsonplaceholder.typicode.com/posts"
    
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
