//
//  AlamofireNetworkManager.swift
//  Networking
//
//  Created by Roma Bogatchuk on 20.11.2022.
//

import Foundation
import Alamofire

class AlamofireNetworkManager {
    private init(){}
    static let shared = AlamofireNetworkManager()
    var onProgress: ((Double) -> ())?
    var completed: ((String) -> ())?
    
    func sendRequest(url: String, completion: @escaping (_ courses: [Course]) -> ()){
        guard let url = URL(string: url) else {return}
        AF.request(url).responseDecodable(of: [Course].self) { response in
//            print("response")
//            print(response.response)
//            print("response value")
//            print(response.value)
//            print("response description")
//            print(response.description)
//            print("response result")
//            print(response.result)
//            print("response error")
//            print(response.error)
//            print("response request")
//            print(response.request)
            
            guard let courses = response.value else {return}
            completion(courses)
        }
        AF.request(url).responseData { data in
            switch data.result {
            case .success(let data):
                do{
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let courses = try decoder.decode([Course].self, from: data)
                    print(courses)

                } catch let error{
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
            
//            guard let data = data.value else { return }
//            do{
//                let decoder = JSONDecoder()
//                decoder.keyDecodingStrategy = .convertFromSnakeCase
//                let courses = try decoder.decode([Course].self, from: data)
//                print(courses)
//
//            } catch let error{
//                print(error)
//            }
        }
    }
    
    func downloadImage(url: String, completion: @escaping (_ image: UIImage) -> ()){
        
        guard let url = URL(string: url) else { return }

        AF.request(url).responseData { data in
            guard let data = data.value, let image = UIImage(data: data) else { return }
            completion(image)
        }
    }
    
    func downdloadImageWithProgress(url: String, completion: @escaping (_ image: UIImage) -> ()){
        print("1")
        guard let url = URL(string: url) else { return }
        print("2")
        AF.request(url).validate().downloadProgress { progress in
            
            print("totalUnitCount:, \(progress.totalUnitCount)")
            print("completedUnitCount: \(progress.completedUnitCount)")
            print("fractionCompleted: \(progress.fractionCompleted)")
            print("localizedDescription:\(progress.localizedDescription!)")
            print("-------")
            
            self.onProgress?(progress.fractionCompleted)
            self.completed?(progress.localizedDescription)
        }.response { response in
            
            guard let data = response.data,
                  let image = UIImage(data: data)else
                    { return }
            DispatchQueue.main.async {
                completion(image)
            }
        }
        
    }
    
    func postRequest(url: String, completion: @escaping (_ courses: [Course]) -> ()){
        guard let url = URL(string: url) else {return}
        
        let userData: [String: Any] = [
            "name": "Network Requests",
            "link": "https://swiftbook.ru/contents/our-first-applications/",
            "imageUrl": "https://swiftbook.ru/wp-content/uploads/sites/2/2018/08/notifications-course-with-background.png",
            "numberOfLessons": 18,
            "numberOfTests": 10
        ]
        
        AF.request(url, method: .post, parameters: userData).responseData { data in
            guard let statusCode = data.response?.statusCode else {return}
            print(statusCode)
           
            
            switch data.result {
            case .success(let data):
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    print(json!)
                    guard
                        let course = Course(json: json!)
                        else { return }
                    
                    print(course)
                    var courses = [Course]()
                    courses.append(course)
                    
                    completion(courses)
                } catch let error{
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
            
        }
    }
     func putRequest(url: String, completion: @escaping (_ courses: [Course])->()) {
        
        guard let url = URL(string: url) else { return }
        
        let userData: [String: Any] = [
            "name": "Network Requests with Alamofire ",
            "link": "https://swiftbook.ru/contents/our-first-applications/",
            "imageUrl": "https://swiftbook.ru/wp-content/uploads/sites/2/2018/08/notifications-course-with-background.png",
            "numberOfLessons": 18,
            "numberOfTests": 10
        ]
        
         AF.request(url, method: .put, parameters: userData).responseData { data in
             guard let statusCode = data.response?.statusCode else {return}
             print(statusCode)
            
             
             switch data.result {
             case .success(let data):
                 do{
                     let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                     print(json!)
                     guard
                         let course = Course(json: json!)
                         else { return }
                     
                     print(course)
                     var courses = [Course]()
                     courses.append(course)
                     
                     completion(courses)
                 } catch let error{
                     print(error)
                 }
             case .failure(let error):
                 print(error)
             }
             
         }
    }
    
}

