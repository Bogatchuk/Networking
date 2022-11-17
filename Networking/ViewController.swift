//
//  ViewController.swift
//  Networking
//
//  Created by Roma Bogatchuk on 17.11.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var getImageButton: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        activityIndicator.hidesWhenStopped = true
    }


    @IBAction func getImagePressed(_ sender: UIButton) {
        activityIndicator.startAnimating()
        getImageButton.isEnabled = false
        label.isHidden = true

        guard let url = URL(string: "https://vjoy.cc/wp-content/uploads/2019/12/3dr-19.jpg") else { return }

        let session = URLSession.shared
        
        session.dataTask(with: url) { data, response, error in
            guard let data = data, let image = UIImage(data: data) else {return}
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.imageView.image = image
            }
        }.resume()
        
    }
}

