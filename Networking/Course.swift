//
//  Course.swift
//  Networking
//
//  Created by Roma Bogatchuk on 17.11.2022.
//

import Foundation

struct Course: Decodable {
    let name: String
    let link: String?
    let imageUrl: String?
    let numberOfLessons: Int?
    let numberOfTests: Int?
    
}
