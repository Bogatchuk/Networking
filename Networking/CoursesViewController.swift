//
//  CoursesViewController.swift
//  Networking
//
//  Created by Roma Bogatchuk on 17.11.2022.
//

import UIKit

class CoursesViewController: UITableViewController {
    
    private let jsonUrl = "https://swiftbook.ru//wp-content/uploads/api/api_courses"
    private var courses: [Course] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return courses.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellCourse", for: indexPath) as! CourseCell
        
        let course = courses[indexPath.row]
        cell.configire(with: course)
        
        return cell
    }
    
    func fetchData(){
        NetworkManager.shared.fetchData(url: jsonUrl) { courses in
            self.courses = courses
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }

    // MARK: - Navigation

     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         let webViewController = segue.destination as! WebViewController
         guard let indexPath = tableView.indexPathForSelectedRow else {return}
         guard let url = URL(string:courses[indexPath.row].link!) else {return}
         webViewController.url = url
         webViewController.course = courses[indexPath.row].name
         
     }

}

extension CoursesViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(110)
    }
}
