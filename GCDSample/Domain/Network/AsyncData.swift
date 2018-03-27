//
//  AsyncData.swift
//  GCDSample
//
//  Created by Sergio Cabrera Hernández on 27/3/18.
//  Copyright © 2018 Fernando Rodriguez. All rights reserved.
//
// Implementación del actor para la descarga de una imagen

import UIKit

typealias ImageCompletion = (UIImage)->()
class AsyncImage {
    private var placeHolderImage: UIImage
    private let remoteImageURL: URL
    private var remoteImage:  UIImage?
    private let privateQueue: DispatchQueue
    private var completion: ImageCompletion
    
    // Propiedad computada
    var image: UIImage {
        get {
            guard let img = remoteImage else {
                return placeHolderImage
            }
            return img
        }
    }
    
    
    init(placeHolderImage img: UIImage,
         remoteImageURL url: URL,
         completion: @escaping ImageCompletion) {
        
        placeHolderImage = img
        remoteImageURL = url
        remoteImage = nil
        privateQueue = DispatchQueue(label: "io.keepcoding.asyncImage\(url)")
        self.completion = completion
        
        // Start downloading
        downloadRemoteImage()
    }
    
    func downloadRemoteImage() {
        privateQueue.async {
            // Estoy en mi cola privada
            if let data = try? Data(contentsOf: self.remoteImageURL) ,
                let image = UIImage(data: data) {
                self.remoteImage = image
                
                // Pasamos la imagen a completion y hemos terminado
                // Las clausuras de finalización siempre deben ejecutarse en la cola main
                // para evitar que haya un ciclo de referencias (ARC) se debe usar self como weak
                DispatchQueue.main.async { [weak self] in
                    self?.completion(image)
                }
            }
            else {
                // Se ha producido un error
            }
        }
    }
}


