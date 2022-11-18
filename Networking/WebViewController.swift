//
//  WebViewController.swift
//  Networking
//
//  Created by Roma Bogatchuk on 18.11.2022.
//

import UIKit
import WebKit
class WebViewController: UIViewController {

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var webView: WKWebView!
    
    private var progressKVOhandle: NSKeyValueObservation?
    
    var course: String!
    var url: URL!
    override func viewDidLoad() {
        super.viewDidLoad()

        title = course
        let request = URLRequest(url: url)
        webView.load(request)
        
        progressKVOhandle = webView.observe(\.estimatedProgress) { [weak self] (object, _) in
                            self?.progressView.setProgress(Float(object.estimatedProgress), animated: true)
                            self?.progressView.isHidden = self?.webView.estimatedProgress == 1
                        }
    }

}
