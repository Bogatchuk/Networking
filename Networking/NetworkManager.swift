//
//  NetworkManager.swift
//  Networking
//
//  Created by Roma Bogatchuk on 18.11.2022.
//

import UIKit
class NetworkManager {
    private init(){}
    static let shared = NetworkManager()
    
    func getRequest(url: String){
        guard let url = URL(string: url) else { return }
        
        let session = URLSession.shared
        session.dataTask(with: url) { data, response, error in
            guard let response = response, let data = data else { return }
            print(response)
            print(data)
            
            do {
                let json = try JSONSerialization.jsonObject(with: data)
                print(json)
            } catch {
                print(error)
            }
            
        }.resume()
    }
    
    func postRequest(url: String){
        guard let url = URL(string: url) else { return }
        
        let userData = ["Course": "Networking", "Lessons": "GET and POST request"]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: userData) else { return }
        request.httpBody = httpBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
            guard let response = response, let data = data else { return }
            print(response)
            print(data)
            
            do {
                let json = try JSONSerialization.jsonObject(with: data)
                print(json)
            } catch {
                print(error)
            }
            
        }.resume()
        
    }
    
    func downloadImage(url: String, completion: @escaping (_ image: UIImage) -> ()){
    
        guard let url = URL(string: "https://vjoy.cc/wp-content/uploads/2019/12/3dr-19.jpg") else { return }

        let session = URLSession.shared
        
        session.dataTask(with: url) { data, _, _ in
            guard let data = data, let image = UIImage(data: data) else {return}
            DispatchQueue.main.async {
               completion(image)
            }
        }.resume()
    }
    
    func fetchData(url: String, completion: @escaping (_ courses: [Course]) -> ()){
        
        guard let url = URL(string: url) else { return }
        
        let session = URLSession.shared
        
        session.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            
            do{
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let courses = try decoder.decode([Course].self, from: data)
                completion(courses)

            } catch let error{
                print(error)
            }
        }.resume()
        
    }
}
