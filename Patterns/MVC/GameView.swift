//
//  GameView.swift
//  Patterns
//
//  Created by Drew Brokamp on 5/21/20.
//  Copyright © 2020 Drew Brokamp. All rights reserved.
//

import SpriteKit

class GameView {

    var actionButton: ButtonColor
    var undoButton: ButtonColor
    var levelButton: ButtonColor
    var levelWonButton: ButtonColor
    
    var boxColorOptions: [UIColor]
    var gameScene: SKScene
    
    var boxPositions: [CGPoint]

    init(in scene: SKScene) {

        gameScene = scene
        boxPositions = [CGPoint]()

        actionButton = ButtonColor(boxSize: CGSize(width: gameScene.size.width / 4, height: gameScene.size.height * 0.03),                    defaultTexture: .americanRiver, selectedTexture: .soothingBreez, disabledTexture: .americanRiver)
        undoButton = ButtonColor(boxSize: CGSize(width: gameScene.size.width / 8, height: gameScene.size.height * 0.03),                    defaultTexture: .americanRiver, selectedTexture: .soothingBreez, disabledTexture: .americanRiver)
        levelButton = ButtonColor(boxSize: CGSize(width: 30, height: gameScene.size.height * 0.03), defaultTexture:                        .americanRiver, selectedTexture: .soothingBreez, disabledTexture: .americanRiver)
        
        levelWonButton = ButtonColor(boxSize: CGSize(width: gameScene.size.width / 4, height: gameScene.size.height * 0.03),                    defaultTexture: .americanRiver, selectedTexture: .soothingBreez, disabledTexture: .americanRiver)
        
        boxColorOptions = [.lightGreenishBlue, .mintLeaf, .sourLemon, .brightYarrow,
                           .fadedPoster, .robinEggBlue, .firstDate, .orangeVille,
                           .greenDarnerTail, .electronBlue, .pinkGlamor, .chiGong,
                           .shyMoment, .exodusFruit, .picoPink, .prunusAvium,
                           .jacksonPurple, .luckyPoint, .flourescentRed, .eyeOfNewt,
                           .c64Purple, .liberty, .syntheticPumpkin, .chileanFire,
                           .summerSky, .devilBlue, .mandarinSorbet, .alamedaOchre,
                           .celestialGreen, .palmSpringsSplash, .spicedButterNut, .desert,
                           .paradiseGreen, .auroraGreen, .waterfall, .reefEncounter,
                           .spray, .dupain, .goodSamaritan, .forestBlues]
        
        boxColorOptions.shuffle()
    }
    
    func showLevelWonButton() {
        levelWonButton.label.text = "Level Won!"
        levelWonButton.zPosition = ZPositions.button
        levelWonButton.isEnabled = false
        levelWonButton.size = CGSize(width: gameScene.size.width / 2, height: gameScene.size.height * 0.10)
        levelWonButton.position = CGPoint(x: gameScene.frame.midX, y: gameScene.frame.midY)
        gameScene.addChild(levelWonButton)
    }
    
    func drawHUD() {
        // Add actionButton to scene
        actionButton.alpha = 0.80
        actionButton.zPosition = ZPositions.button
        actionButton.setButtonLabel(title: "Play Pattern", font: "Helvetica-Bold", fontSize: 11.0)
        actionButton.position = CGPoint(x: gameScene.frame.midX, y: gameScene.frame.maxY - 50.0)
        actionButton.isEnabled = true
        gameScene.addChild(actionButton)


        // Add undo button to scene
        undoButton.alpha = 0.80
        undoButton.zPosition = ZPositions.button
        undoButton.setButtonLabel(title: "Undo", font: "Helvetica-Bold", fontSize: 11.0)
        undoButton.position = CGPoint(x: gameScene.frame.minX + 50, y: gameScene.frame.maxY - 30.0)
        undoButton.isEnabled = false
        gameScene.addChild(undoButton)

        // Add levelButton to scene
        levelButton.alpha = 0.80
        levelButton.position = CGPoint(x: gameScene.frame.maxX - 30, y: gameScene.frame.maxY - 30)
        levelButton.setButtonLabel(title: "" as NSString, font: "Helvetica-Bold", fontSize: 11.0)
        levelButton.zPosition = ZPositions.button
        levelButton.addRoundedCorners(withRadius: 30.0)
        levelButton.isEnabled = false
        gameScene.addChild(levelButton)
        
    }

    func drawBoxes(with boxArray: [Box], with boxSize: CGSize, columns: Int, rows: Int) {
        
        let row0: CGFloat = 0.0
        let row1: CGFloat = 0.0 + boxSize.height
        let row2: CGFloat = 0.0 + boxSize.height * 2
        let row3: CGFloat = 0.0 + boxSize.height * 3
        let row4: CGFloat = 0.0 + boxSize.height * 4
        let row5: CGFloat = 0.0 + boxSize.height * 5
        let row6: CGFloat = 0.0 + boxSize.height * 6
        let row7: CGFloat = 0.0 + boxSize.height * 7
        let row8: CGFloat = 0.0 + boxSize.height * 8
        let row9: CGFloat = 0.0 + boxSize.height * 9
        
        let rowPositions = [row0, row1, row2, row3, row4, row5, row6, row7, row8, row9]
        
        let column0: CGFloat = 0.0
        let column1: CGFloat = 0.0 + boxSize.width
        let column2: CGFloat = 0.0 + boxSize.width * 2
        let column3: CGFloat = 0.0 + boxSize.width * 3
        
        let columnPositions = [column0, column1, column2, column3]
        
        var row = 0
        var column = 0
        var box = 0
        
        while row <  rows {
            
            while column < columns {
                
                boxArray[box].position = CGPoint(x: columnPositions[column], y: rowPositions[row])
                gameScene.addChild(boxArray[box])
                boxPositions.append(boxArray[box].position)
                box += 1
                column += 1
            }
            
            column = 0
            row += 1
            
        }
        
    }
    
    func moveBoxes(boxes: [Box]) {
        self.boxPositions.shuffle()
        
        var x = 0
        
        while x < boxes.count {
            boxes[x].run(SKAction.move(to: boxPositions[x], duration: 0.4))
            x += 1
        }
    }
    
    func flashBox(number: Int, boxes: [Box]) {
        
        let fadeOut = SKAction.fadeOut(withDuration: 0.25)
        let fadeIn = SKAction.fadeIn(withDuration: 0.25)
        let newSequence = SKAction.sequence([fadeOut, fadeIn])
        
        boxes[number].run(newSequence)
        
    }
    
}
