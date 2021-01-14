//
//  GameData.swift
//  Patterns
//
//  Created by Drew Brokamp on 5/22/20.
//  Copyright © 2020 Drew Brokamp. All rights reserved.
//

import SpriteKit

struct GameData {
    
    var level: Int = UserDefaults.standard.integer(forKey: "level")
    var currentPatternCount: Int = UserDefaults.standard.integer(forKey: "currentPatternCount")
    var didAskForReview: Bool = UserDefaults.standard.bool(forKey: "didAskForReview")
    var playCounter: Int = UserDefaults.standard.integer(forKey: "playCounter")
    let minPatternCount = 3
    var rows: Int = 0
    var columns: Int = 0
    var maxPatternCount: Int = 0
    
    init() {
        if level == 0 {
            level = 1
        }
        
        if currentPatternCount == 0 {
            currentPatternCount = minPatternCount
        }
        
        switch level {
        case 1:
            columns = 1
            rows = 5
            maxPatternCount = 5
        case 2:
            columns = 1
            rows = 6
            maxPatternCount = 6
        case 3:
            columns = 1
            rows = 7
            maxPatternCount = 7
        case 4:
            columns = 2
            rows = 4
            maxPatternCount = 8
        case 5:
            columns = 2
            rows = 5
            maxPatternCount = 10
        case 6:
            columns = 2
            rows = 6
            maxPatternCount = 12
        case 7:
            columns = 2
            rows = 7
            maxPatternCount = 14
        case 8:
            columns = 2
            rows = 8
            maxPatternCount = 16
        case 9:
            columns = 3
            rows = 6
            maxPatternCount = 18
        case 10:
            columns = 3
            rows = 8
            maxPatternCount = 24
        case 11:
            columns = 4
            rows = 8
            maxPatternCount = 32
        default:
            print("Level failed to load")
        }
        
        print("Did Ask For Review: \(didAskForReview)")
        print("Level \(level)")
        print("Rows: \(rows)")
        print("Columns: \(columns)")
        print("MaxPattern: \(maxPatternCount)")
        print("Current Pattern Count: \(currentPatternCount)")
    }
    
    func saveGameData() {
        UserDefaults.standard.set(self.level, forKey: "level")
        UserDefaults.standard.set(self.currentPatternCount, forKey:"currentPatternCount")
        UserDefaults.standard.set(self.playCounter, forKey: "playCounter")
        UserDefaults.standard.set(self.didAskForReview, forKey: "didAskForReview")
    }
    
    mutating func gameWon() {
        playCounter += 1
        currentPatternCount += 1
        
        saveGameData()
    }
    
    mutating func gameLost() {
        playCounter += 1
        
        saveGameData()
    }
    
    mutating func levelWon() {
        playCounter += 1
        level += 1
        currentPatternCount = minPatternCount
        
        saveGameData()
    }
    
}
