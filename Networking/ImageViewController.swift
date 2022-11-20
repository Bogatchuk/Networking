//
//  ViewController.swift
//  Networking
//
//  Created by Roma Bogatchuk on 17.11.2022.
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var completedLabel: UILabel!
    
    private let url = "https://vjoy.cc/wp-content/uploads/2019/12/3dr-19.jpg"
    private let largeImageUrl = "https://i.imgur.com/3416rvI.jpg"
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        progressView.isHidden = true
        completedLabel.isHidden = true
        
    }

    func getImage(){
        
        NetworkManager.shared.downloadImage(url: url){ image in
            self.activityIndicator.stopAnimating()
            self.imageView.image = image
        }
    }
    
    func getImageAF(){
        
        AlamofireNetworkManager.shared.downloadImage(url: url) { image in
            self.activityIndicator.stopAnimating()
            self.imageView.image = image
        }
    }
    
    func downdloadImageWithProgress(){
        
        AlamofireNetworkManager.shared.onProgress = { progress in
            self.progressView.isHidden = false
            self.progressView.progress = Float(progress)
        }
        
        AlamofireNetworkManager.shared.completed = { completed in
            self.completedLabel.text = completed
            self.completedLabel.isHidden = false
            
        }
        AlamofireNetworkManager.shared.downdloadImageWithProgress(url: largeImageUrl) { image in
            self.activityIndicator.stopAnimating()
            self.progressView.isHidden = true
            self.completedLabel.isHidden = true
            self.imageView.image = image
            //self.progressView.progress = image.pro
        }
    }
}

