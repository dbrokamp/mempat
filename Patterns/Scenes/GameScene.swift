////
////  GameScene.swift
////  Patterns
////
////  Created by Drew Brokamp on 5/20/20.
////  Copyright © 2020 Drew Brokamp. All rights reserved.
////
//

import SpriteKit
import StoreKit
import GameplayKit

class GameScene: SKScene {
    
    var game: GameData!
    var gameController: GameController!
    var gameView: GameView!
    
    var boxSize: CGSize!
    var checkedSelection: Bool!
    
    var stateMachine: GKStateMachine!
        
    override func didMove(to view: SKView) {

        initializeGame()
        initializeView()
        
        askForReview()
        
        stateMachine = GKStateMachine(states: [StartGameState(scene: self),
                                                PlayingPatternState(scene: self),
                                                SelectPatternState(scene: self)])
        
    }
    
    func initializeGame() {
        game = GameData()
        gameController = GameController()
        gameView = GameView(in: self)
        
        boxSize = CGSize(width: view!.frame.size.width / CGFloat(game.columns), height: view!.frame.size.height / CGFloat(game.rows))
        checkedSelection = false
        gameController.createBoxesArray(with: boxSize, with: gameView.boxColorOptions, with: game.maxPatternCount)
    }
    
    func initializeView() {
        gameView.drawHUD()
        gameView.drawBoxes(with: gameController.boxes, with: boxSize, columns: game.columns, rows: game.rows)
        gameView.levelButton.setButtonLabel(title: "\(game.level)" as NSString, font: "Helvetica-Bold", fontSize: 11.0)
        gameView.actionButton.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(moveBoxes))
    }
    
    @objc func moveBoxes() {
        gameView.moveBoxes(boxes: gameController.boxes)
        
        run(SKAction.wait(forDuration: 1.5)) {
            self.patternPlayingState()
        }
    }
    
    func newGameState() {
        self.removeAllChildren()
        self.removeAllActions()
        let newScene = GameScene(size: view!.bounds.size)
        newScene.scaleMode = self.scaleMode
        let animation = SKTransition.fade(with: .chiGong, duration: 1.0)
        self.view?.presentScene(newScene, transition: animation)
        

        runAd()
    }
    

    
    
    func patternPlayingState() {
        gameController.createPattern(with: game.currentPatternCount)
        gameView.actionButton.label.text = "Follow Pattern"
        
        var numberInPattern = game.currentPatternCount
        var patternCountLoop = 0
        let waitDuration: Double = 1.0 - (Double(game.level) * 0.03)
        let wait = SKAction.wait(forDuration: waitDuration)
        let block = SKAction.run {
            [unowned self] in
            
            if numberInPattern > 0 {
                self.gameView.flashBox(number: self.gameController.pattern[patternCountLoop], boxes: self.gameController.boxes)
                numberInPattern = numberInPattern - 1
                patternCountLoop += 1
            } else {
                self.removeAction(forKey: "countdown")
                self.selectBoxesState()
            }
        }
        
        let sequence = SKAction.sequence([wait, block])
        run(SKAction.repeatForever(sequence), withKey: "countdown")
        
    }
    
    func selectBoxesState() {
        gameView.actionButton.label.text = "Select Pattern"
        gameController.enableAllBoxes()
        gameView.undoButton.isEnabled = true
        gameView.undoButton.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(undoBoxSelect))
        
        
        
        for box in gameController.boxes {
            box.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(addToSelection(sender:)))
        }
        
    }
    
    func winState() {
        gameView.actionButton.label.text = "Correct!"
        
        if game.currentPatternCount == game.maxPatternCount {
            levelWonState()
        } else {
            game.gameWon()
        }

        run(SKAction.wait(forDuration: 2.0)) {
            self.newGameState()
        }
    }
    
    func loseState() {
        gameView.actionButton.label.text = "Incorrect!"
        
        game.gameLost()
        
        run(SKAction.wait(forDuration: 2.0)) {
            self.newGameState()
        }

    }
    
    func levelWonState() {
        gameView.showLevelWonButton()
        game.levelWon()
        
        run(SKAction.wait(forDuration: 2.0)) {
            self.newGameState()
        }
        
    }
    
    //MARK: Selection Functions
    
    @objc func undoBoxSelect() {
        if gameController.playerSelectedBoxes.isEmpty == true {
            return
        } else {
            gameController.playerSelectedBoxes.last!.removeAllChildren()
            gameController.playerSelectedBoxes.removeLast()
        }
    }
    
    @objc func addToSelection(sender: Box) {
        
        if gameController.playerSelectedBoxes.contains(sender) {
            return
        } else {
            let newRect = SKShapeNode(rectOf: sender.size, cornerRadius: 2.0)
            newRect.position = CGPoint(x: 0.0 + sender.size.width / 2, y: 0.0 + sender.size.height / 2)
            newRect.lineWidth = 5.0
            newRect.strokeColor = .white
            newRect.zPosition = 100.0
            sender.addChild(newRect)
            gameController.playerSelectedBoxes.append(sender)
            sender.setButtonLabel(title: "\(gameController.playerSelectedBoxes.count)", font: "Helvetica-Bold", fontSize: 20.0)
            sender.label.fontColor = .white
            sender.label.position = CGPoint(x: 0.0 + sender.size.width / 2, y: 0.0 + sender.size.height / 2)
        }
    }
    
    
    //MARK: Helper Functions
    
    func askForReview() {
        if game.level >= 2 && game.didAskForReview == false {
            SKStoreReviewController.requestReview()
            game.didAskForReview = true
        } else {
            game.didAskForReview = false
        }
        
        UserDefaults.standard.set(game.didAskForReview, forKey: "didAskForReview")
            
    }
    
    func runAd() {
        if game.playCounter % 3 == 0 {
            NotificationCenter.default.post(name: .showInterstitialAd, object: nil)
        }
    }
    
    func compareArrays(firstArray: [Int], secondArray: [SKNode]) -> Bool {
        
        var areTheyEqual: Bool!
        
        var firstArrayNames = [String]()
        var secondArrayNames = [String]()
        
        var x = 0
        
        while x < game.currentPatternCount {
            firstArrayNames.append("box\(firstArray[x])")
            secondArrayNames.append(secondArray[x].name!)
            x += 1
        }
        
        if firstArrayNames == secondArrayNames {
            areTheyEqual = true
        } else {
            areTheyEqual = false
        }
        
        return areTheyEqual
        
    }
    
    override func didFinishUpdate() {
        if gameController.playerSelectedBoxes.count == game.currentPatternCount && gameController.playerSelectedBoxes.count != 0 && checkedSelection == false  {
            gameController.disableAllBoxes()
            let selection = compareArrays(firstArray: gameController.pattern, secondArray: gameController.playerSelectedBoxes)
            if selection == true {
                print("You is correct.")
                self.winState()
            } else if selection == false {
                self.loseState()
            }
            checkedSelection = true
        }
    }
}































//import SpriteKit
//
//class GameScene: SKScene {
//
//    var gameView: View!
//    var checkedSelection: Bool!
//
//    override func didMove(to view: SKView) {
//        gameView = View(drawScene: self)
//
//        gameView.startGameButton.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(startGame))
//        gameView.undoButton.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(undoBoxSelect))
//        checkedSelection = false
//
//        gameStateMenu()
//
//    }
//
//    //MARK: GAME STATES
//
//    //Game State: Menu
//    func gameStateMenu() {
//        gameView.drawHUD()
//        gameView.drawBoxes()
//        gameView.startGameButton.isEnabled = true
//        gameView.startGameButton.label.text = "Start Game"
//        gameView.undoButton.isEnabled = false
//
//    }
//
//    //Game State: Create and Show Pattern to Player
//    func gameStateCreateAndShowPatternToPlayer() {
//
//        gameView.modelController.createRandomPattern()
//
//        run(SKAction.wait(forDuration: 0.5)) {
//            self.gameView.showPattern()
//
//        }
//        gameView.undoButton.isEnabled = true
//        gameView.startGameButton.isEnabled = false
//    }
//
//    //Game State: Wait for Player to Select number of boxes in Pattern and Evaluate When They Match
//    override func didFinishUpdate() {
//
//        if gameView.modelController.game.selectedBoxes.count == gameView.modelController.game.getCurrentPatternCount() && gameView.modelController.game.selectedBoxes.count != 0 && checkedSelection == false  {
//                let selection = gameView.modelController.compareArrays(firstArray: gameView.modelController.game.pattern, secondArray: gameView.modelController.game.selectedBoxes)
//                        if selection == true {
//                            gameWon()
//                        } else if selection == false {
//                            gameLost()
//                        }
//            checkedSelection = true
//        } else {
//            return
//        }
//
//    }
//
//    //Game State: Game lost
//    func gameLost() {
//        gameView.undoButton.isEnabled = false
//        gameView.startGameButton.label.text = "Wrong!"
//
//        //Save the current player data
//        gameView.modelController.game.saveGame()
//
//        //Is it time to show an ad?
//        runAd()
//
//        //Load a new GameScene
//        loadNewScene()
//
//    }
//
//    //Game State: Game Won
//    func gameWon() {
//        gameView.undoButton.isEnabled = false
//        gameView.startGameButton.label.text = "Right!"
//
//
//        //Save the current player data
//        gameView.modelController.game.saveGame()
//
//        //Is it time to show an ad?
//        runAd()
//
//        //Did the player complete a level?
//        if gameView.modelController.game.getCurrentPatternCount() == gameView.modelController.game.getMaxPatternCount() {
//            levelWon()
//        } else {
//            loadNewScene()
//        }
//
//    }
//
//    //Game State: Level Won
//    func levelWon() {
//
//    }
//
//    func loadNewScene() {
//
//        self.removeAllChildren()
//        self.removeAllActions()
//        let newScene = GameScene(size: view!.bounds.size)
//        newScene.scaleMode = self.scaleMode
//        let animation = SKTransition.fade(with: .brightYarrow, duration: 1.0)
//        self.view?.presentScene(newScene, transition: animation)
//
//    }
//
//    func runAd() {
//        if gameView.modelController.game.getPlayCounter() % 3 == 0 {
//            NotificationCenter.default.post(name: .showInterstitialAd, object: nil)
//        } else {
//            return
//        }
//    }
//
//    //MARK: BUTTON ACTIONS
//
//    @objc func startGame() {
//
//        gameStateCreateAndShowPatternToPlayer()
//
//    }
//
//    @objc func undoBoxSelect() {
//        if gameView.modelController.game.selectedBoxes.isEmpty == true {
//            return
//        } else {
//            gameView.modelController.game.selectedBoxes.last!.removeAllChildren()
//            gameView.modelController.game.selectedBoxes.removeLast()
//        }
//    }
//
//}
