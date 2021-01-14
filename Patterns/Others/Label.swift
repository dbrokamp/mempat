//
//  Label.swift
//  Memory+Concentration
//
//  Created by Drew Brokamp on 10/29/20.
//

import SpriteKit

class Label: SKLabelNode {
    
    init(text: String) {
        
        super.init()
        self.text = text
        self.zPosition = ViewZPositions.hudLabel
        self.fontName = "SFPro-Regular"
        self.fontSize = FontSizes.hudLabel
        self.fontColor = .white
        self.horizontalAlignmentMode = .center
        self.verticalAlignmentMode = .center
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func flashLabel() {
        let flashDown: SKAction = SKAction.fadeAlpha(to: 0.5, duration: 0.5)
        let flashUp: SKAction = SKAction.fadeAlpha(to: 1.0, duration: 0.5)
        let fadeSequence = SKAction.sequence([flashDown, flashUp])
        
        self.run(fadeSequence)
    }
}


