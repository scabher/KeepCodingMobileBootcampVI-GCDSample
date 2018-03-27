//
//  RemoteImages.swift
//  GCDSample
//
//  Created by Fernando Rodriguez on 3/22/18.
//  Copyright © 2018 Fernando Rodriguez. All rights reserved.
//

import Foundation


typealias URLString = String
enum RemoteImages : URLString{
    
    case danny = "https://typeset-beta.imgix.net/rehost/2016/9/13/9f6e6cc4-c86b-4cbb-8d7d-bedf3f8b3937.jpg"
    case missandei = "https://www.farfarawaysite.com/section/got/gallery3/gallery4/hires/15.jpg"
    case olenna = "https://cdn.gratisography.com/photos/447H.jpg"
    case cersei = "https://hdqwalls.com/wallpapers/cersei-lannister-game-of-thrones-season-7-39.jpg"
    case wrongURLString = "https://germguy.files.wordpress.com/2016/11/jedi.jpg"
    
    static func url(_ aCase: RemoteImages)-> URL?{
        
        let strRep = aCase.rawValue
        return URL(string: strRep)
        
    }
    
    
}
