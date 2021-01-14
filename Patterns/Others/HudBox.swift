//
//  HudBox.swift
//  Mind Match Game
//
//  Created by Drew Brokamp on 11/10/20.
//  Copyright © 2020 Drew Brokamp. All rights reserved.
//

import SpriteKit

class HudBox: SKSpriteNode {
    
    var box: SKShapeNode!
    var label: Label!
    var dataLabel: Label!
    
    init(boxSize: CGSize, labelText: String, dataLabelText: String) {
        label = Label(text: labelText)
        dataLabel = Label(text: dataLabelText)
        
        super.init(texture: nil, color: .clear, size: boxSize)
        self.zPosition = ViewZPositions.hudBox
        setupUpBox()
        setupLabel()
        setupDataLabel()
        
    }
    
    public func alignLabelLeft() {
        label.position = CGPoint(x: 0 - self.frame.width, y: 0)
        label.horizontalAlignmentMode = .right
    }
    
    public func setDataLabelText(text: String) {
        self.dataLabel.text = text
    }
    
    private func setupUpBox() {
        box = SKShapeNode(rectOf: size, cornerRadius: 3.0)
        box.fillColor = .reefEncounter
        box.zPosition = ViewZPositions.hudBox
        self.addChild(box)

    }
    
    private func setupLabel() {
        label.position = CGPoint(x: 0, y: self.frame.maxY + label.frame.height)
        self.addChild(label)
    }
    
    private func setupDataLabel() {
        dataLabel.position = CGPoint(x: 0, y: 0)
        self.addChild(dataLabel)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
