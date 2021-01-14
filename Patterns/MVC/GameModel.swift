//
//  GameModel.swift
//  Patterns
//
//  Created by Drew Brokamp on 5/21/20.
//  Copyright © 2020 Drew Brokamp. All rights reserved.
//

// Have boxes appear on screen for first load up, start game button in the middle of the screen
// If they answer correctly, rearrange the colors

import SpriteKit

class GameController {

    var pattern: [Int]
    var boxes: [Box]
    var playerSelectedBoxes: [Box]
    var correctAnswer: Bool
    
    init() {
        
        pattern = [Int]()
        boxes = [Box]()
        playerSelectedBoxes = [Box]()
        correctAnswer = false
    
    }
    
    func createBoxesArray(with size: CGSize, with colors: [UIColor], with maxPattern: Int) {
        
        var box = 0
        
        while box < maxPattern {
            
            let newBox = Box(boxSize: size, defaultTexture: colors[box], selectedTexture: .gray, disabledTexture: colors[box])
            newBox.anchorPoint = CGPoint(x: 0.0, y: 0.0)
            newBox.name = "box\(box)"
            boxes.append(newBox)
            box += 1
            
        }
    }
    
}
