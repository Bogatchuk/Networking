//
//  ImageProperties.swift
//  Networking
//
//  Created by Roma Bogatchuk on 18.11.2022.
//

import UIKit

struct ImageProperties {
    let key: String
    let data: Data
    
    init?(withImage image: UIImage, key: String){
        self.key = key
        
        guard let data = image.pngData() else {return nil}
        self.data = data
    }
}

