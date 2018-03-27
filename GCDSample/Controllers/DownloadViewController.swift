//
//  DownloadViewController.swift
//  GCDSample
//
//  Created by Fernando Rodriguez on 3/22/18.
//  Copyright © 2018 Fernando Rodriguez. All rights reserved.
//

import UIKit

// Tenemos que mapear segueID -> RemoteImage -> Método
extension RemoteImages{
    
    static func imageCase(forSegueId segueId: String)-> RemoteImages{
        
        let result : RemoteImages
        
        switch segueId {
        case "secuencialCazurro":
            result = .danny
            
        case "concurrenteBurro":
            result = .missandei
            
            
        case "concurrenteCorrecto":
            result = .olenna
            
        case "concurrenteEspabilao":
            result = .cersei
        default:
            result = .wrongURLString
        }
        
        return result
    }
    
    
}


class DownloadViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    
    var segueId : String = ""
    
    // MARK : - Life cycle of view
    override func viewDidLoad() {
        super.viewDidLoad()
        print("view did load")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("view will appear")
        
        // Según el id de segue, lanzamos una estartegia u otra
        switch RemoteImages.imageCase(forSegueId: segueId) {
        case .danny:
            serialDownload()
        case .missandei:
            concurrentKludge()
        case .olenna:
            correctConcurrent()
            
        case .cersei:
            smartConcurrent(url: RemoteImages.url(.cersei)!){(image) in
                self.imageView.image = image
                self.activityView.isHidden = true
                self.activityView.stopAnimating()
            }
            
        default:
            print("Use AsyncImage")
        }

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("View did appear")
    }
    

    // MARK : - Estrategias
    
    func serialDownload(){
        
        // Gestion UI
        activityView.isHidden = false
        activityView.startAnimating()
        // Se ejecuta siempre al salir de la función. sea como sea
        defer{
            activityView.isHidden = true
            activityView.stopAnimating()
        }
        
        
        
        if let url = RemoteImages.url(.danny),
            let imgData = try? Data(contentsOf: url),
            let image = UIImage(data: imgData){
            
            imageView.image = image
        }
        

    }
    
    func concurrentKludge(){
        
        // Gestion UI
        activityView.isHidden = false
        activityView.startAnimating()
        // Se ejecuta siempre al salir de la función. sea como sea
        defer{
            activityView.isHidden = true
            activityView.stopAnimating()
        }
        
        
        DispatchQueue(label:"io.keepcoding.concurrent").async {
            if let url = RemoteImages.url(.missandei),
                let imgData = try? Data(contentsOf: url),
                let image = UIImage(data: imgData){
                
                self.imageView.image = image
            }
        }
        
    }
    
    func correctConcurrent(){
        
        // Gestion UI
        activityView.isHidden = false
        activityView.startAnimating()
        
        
        
        
        
        DispatchQueue(label:"io.keepcoding.concurrent").async {
            if let url = RemoteImages.url(.olenna),
                let imgData = try? Data(contentsOf: url),
                let image = UIImage(data: imgData){
                
                DispatchQueue.main.async {
                    self.imageView.image = image
                    self.activityView.isHidden = true
                    self.activityView.stopAnimating()
                }
                
            }
        }
    }
    typealias UIImageTask  = (UIImage)->()
    func smartConcurrent(url: URL, completion: @escaping UIImageTask){
        
        // No se desde que cola me llaman, pero sé que lo preparación
        // de la UI tiene que ser en primer plano
        DispatchQueue.main.async {
            // estoy en cola principal
            self.activityView.isHidden = false
            self.activityView.startAnimating()
            
            // Me voy a segundo plano, y voy a aprovechar una de las colas de sistema
            DispatchQueue.global(qos:.default).async {
                // Ya estoy en sefundo plano
                if let data = try? Data(contentsOf: url),
                    let image = UIImage(data: data){
                    
                    // NO tengo ni idea de lo que hará con la imagen la clausura de finalizacion,
                    // pero por si las moscas lo hago en primer plano
                    DispatchQueue.main.async {
                        completion(image)
                    }
                    
                }
            }
        }
        
    }
    
    
}
