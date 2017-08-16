//
//  PowerUp.swift
//  SuperMarioAR
//
//  Created by Bjarne Lundgren on 05/08/2017.
//  Copyright © 2017 Silicon.dk ApS. All rights reserved.
//

import Foundation

enum PowerUp {
    // gain new life!
    case life
    
    // collect extra coin
    case coin
    
    case wand
    //TODO:** more power ups
    
    static var random:PowerUp {
        switch arc4random_uniform(3) {
        case 0: return .life
        case 1: return .coin
        case 2: return .wand
        default: fatalError()
        }
    }
}
