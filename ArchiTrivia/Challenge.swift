//
//  Challenge.swift
//  ArchiTrivia
//
//  Created by Cem Eteke on 7/16/15.
//  Copyright (c) 2015 Cem Eteke. All rights reserved.
//

import Foundation

class Challenge{
    
    var challenged_id: String
    var challenger_id: String
    var id: Int
    var challenger_point: Int
    var challenged_point: Int
    
    init(challenged_id: String, challenger_id: String, id: Int, challenger_point: Int, challenged_point: Int){
        
        self.challenged_id = challenged_id
        self.challenged_point = challenged_point
        self.challenger_id = challenger_id
        self.challenger_point = challenger_point
        self.id = id
    }
    
    
}