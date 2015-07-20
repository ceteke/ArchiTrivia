//
//  Friend.swift
//  ArchiTrivia
//
//  Created by Cem Eteke on 6/30/15.
//  Copyright (c) 2015 Cem Eteke. All rights reserved.
//

import Foundation

class Friend{
    
    var name: String
    var id: String
    var profilePictureURL: String
    var rank: Int
    
    init(name: String, id: String, rank: Int){
        self.name = name
        self.id = id
        self.rank = rank
        profilePictureURL = "http://graph.facebook.com/\(id)/picture?type=normal"
    }
    
    
}