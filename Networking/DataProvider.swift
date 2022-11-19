//
//  DataProvider.swift
//  Networking
//
//  Created by Roma Bogatchuk on 18.11.2022.
//

import UIKit

class DataProvider: NSObject {
    
    //Настройка сесси
    private var downloadTask: URLSessionDownloadTask!
    //текущий путь к файлу
    var fileLocation: ((URL) -> ())?
    var onProgress: ((Double) -> ())?
    
    //параметры конфигурации сессии для фоновой загрузки данных
    private lazy var bgSession: URLSession = {
        //config - определяет поведение нашей сесси при загрузке и выгрузке данных
        //.background дает вохможность фоновой загрузки данных
        let config = URLSessionConfiguration.background(withIdentifier: "Roman.Bogatchuk.Networking")
        //isDiscretionary - определяет могут ли фоновые задачи запланированы по
        //усмотрению системы для обеспечения оптимальной производительности
        config.isDiscretionary = true
        //по завершению загрузки данных приложение запуститься в фоновом режиме
        config.sessionSendsLaunchEvents = true
        
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()
    
    //создание задачи для загрузки данных
    func startDownload(){
        //url - file
        if let url = URL(string: "https://speed.hetzner.de/100MB.bin"){
            //создаем URLSession с настройками конфигурации bgSession
            downloadTask = bgSession.downloadTask(with: url)
            //загрузка начнеться не ранее заданного времени 3с
            downloadTask.earliestBeginDate = Date().addingTimeInterval(3)
            //найболее вероятное количество байт которое клиент ожидает отправить
            downloadTask.countOfBytesClientExpectsToSend = 512
            //найболее вероятное количество байт которое клиент ожидает получить
            downloadTask.countOfBytesClientExpectsToReceive = 100 * 1024 * 1024
            downloadTask.resume()
        }
    }
    
    func stopDownload(){
        //отменяем все задачи
        downloadTask.cancel()
    }
    
}

//MARK: URLSessionDelegate
extension DataProvider: URLSessionDelegate{
    
    //вызываеться по завершению всех фоновых задач с нашим идентификатором,
    //которые нужно передать в AppDelegate, 
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        
        DispatchQueue.main.async {
            //создаем completionHandler в которую передаем захваченое значение
            //нашей сессии из appDelegate.bgSessionCompletionHandler
            //обнуляем appDelegate.bgSessionCompletionHandler
            //вызываем исходны блок completionHandlerчто бы уведомить систему что
            //загрузка была завершена
            guard
                let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                let completionHandler = appDelegate.bgSessionCompletionHandler
            else { return }
            
            appDelegate.bgSessionCompletionHandler = nil
            completionHandler()
                    
        }
    }
}

//MARK: URLSessionDownloadDelegate
extension DataProvider: URLSessionDownloadDelegate{
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        //location - ссылка на временую директорию в которую сохраняеться скачаный файл
        print("Did finish downloading : \(location)")
        
        //захват  location
        DispatchQueue.main.async {
            self.fileLocation?(location)
        }
    }
    
    //ход выполнения загрузки
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        //если файл уже загружен то выхлодим
        guard totalBytesExpectedToWrite != NSURLSessionTransferSizeUnknown else { return }
        //переданные байты / общее количествой байт
        let progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
        print("Download prigress: \(progress) ")
        
        DispatchQueue.main.async {
            self.onProgress?(progress)
        }
    }
    
}


