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
    private let url = "https://vjoy.cc/wp-content/uploads/2019/12/3dr-19.jpg"
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        activityIndicator.hidesWhenStopped = true
        getImage()
    }

    func getImage(){
        
        activityIndicator.startAnimating()
        
        NetworkManager.shared.downloadImage(url: url){ image in
            self.activityIndicator.stopAnimating()
            self.imageView.image = image
        }
    }
}

