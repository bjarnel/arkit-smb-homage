//
//  PlayerState.swift
//  SuperMarioAR
//
//  Created by Bjarne Lundgren on 05/08/2017.
//  Copyright © 2017 Silicon.dk ApS. All rights reserved.
//

import Foundation

struct PlayerState {
    var score:Int
    var lives:Int
    var pickup:Pickup?
    var date:Date
    
    init() {
        score = 0
        lives = 0
        pickup = nil
        date = Date()
    }
    
    private init(score:Int, lives:Int, pickup:Pickup?, date:Date) {
        self.score = score
        self.lives = lives
        self.pickup = pickup
        self.date = date
    }
    
    func setPickup(_ newPickup:Pickup?) -> PlayerState {
        return PlayerState(score: score, lives: lives, pickup: newPickup, date: date)
    }
    
    func gainLife() -> PlayerState {
        return PlayerState(score: score, lives: lives + 1, pickup: pickup, date: date)
    }
    
    func looseLife() -> PlayerState {
        if lives == 0 { return self }
        return PlayerState(score: score, lives: lives - 1, pickup: pickup, date: date)
    }
    
    func incrementScore(_ pts:Int) -> PlayerState {
        return PlayerState(score: score + pts, lives: lives, pickup: pickup, date: date)
    }
}
