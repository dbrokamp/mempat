//
//  Hud.swift
//  Patterns
//
//  Created by Drew Brokamp on 12/13/20.
//  Copyright © 2020 Drew Brokamp. All rights reserved.
//

import SpriteKit

class Hud: SKSpriteNode {
    
    enum ViewPosition {
        case onScreen, offScreen
    }
    
    private var background: SKShapeNode?
    private var offScreenPosition: CGPoint!
    private var onScreenPosition: CGPoint!
    
    init(size: CGSize) {
        
        super.init(texture: nil, color: .clear, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Creates a background for the hud with desired color and alpha, with no line width and a zposition of Hud
    public func createColorBackground(color: UIColor, alpha: CGFloat) {
        background = SKShapeNode(rectOf: self.size)
        background?.fillColor = color
        background?.lineWidth = 0.0
        background?.zPosition = self.zPosition
        background?.alpha = alpha
        self.addChild(background!)
    }
    
    public func createRoundedColorBackground(color: UIColor, alpha: CGFloat, roundedCorner: CGFloat) {
        background = SKShapeNode(rectOf: self.size, cornerRadius: roundedCorner)
        background?.fillColor = color
        background?.zPosition = self.zPosition
        background?.lineWidth = 0.0
        background?.alpha = alpha
        self.addChild(background!)
    }
    
    public func setOnAndOffScreenMenuPositions(onScreen: CGPoint, offScreen: CGPoint) {
        onScreenPosition = onScreen
        offScreenPosition = offScreen
    }
    
    public func setInitialPosition(at: ViewPosition) {
        switch at {
        case .onScreen:
            self.position = onScreenPosition
        case .offScreen:
            self.position = offScreenPosition
        }
    }
    
    public func moveMenu(to: ViewPosition) {
        switch to {
        case .onScreen:
            self.run(SKAction.move(to: onScreenPosition, duration: 1.0))
        case .offScreen:
            self.run(SKAction.move(to: offScreenPosition, duration: 1.0))
        }
        
    }
}
