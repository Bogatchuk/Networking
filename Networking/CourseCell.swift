//
//  CourseCell.swift
//  Networking
//
//  Created by Roma Bogatchuk on 17.11.2022.
//

import UIKit

class CourseCell: UITableViewCell {

    @IBOutlet weak var lessonsLabel: UILabel!
    
    @IBOutlet weak var testslabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageCourse: UIImageView!
    
    func configire(with course: Course){
        self.nameLabel.text = course.name
        self.lessonsLabel.text = "Lessons \(course.numberOfLessons ?? 0)"
        self.testslabel.text = "Test \(course.numberOfTests ?? 0)"
        
        guard let imageUrl = URL(string: course.imageUrl!) else { return }
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageUrl) else { return }
            guard let image = UIImage(data: imageData) else { return }
            DispatchQueue.main.async {
                self.imageCourse.image = image
                
            }
        }
        

    }
    
}
