//
//  DrewButon.swift
//  ButtonTest
//
//  Created by Drew Brokamp on 11/20/20.
//  Copyright © 2020 Drew Brokamp. All rights reserved.
//
// Initializes basic button
// Based on FTButtonNode:
// http://stackoverflow.com/questions/19082202/setting-up-buttons-in-skscene



import SpriteKit

protocol ButtonProtocol: class {
    func buttonPressed(sender: Button)
}

class Button: SKSpriteNode {
    
    enum ActionType: Int {
        case TouchUpInside = 1,
             TouchDown, TouchUp
    }
    
    private var isEnabled: Bool = true {
        didSet {
            color = isEnabled ? disabledColor : defaultColor
        }
    }
    private var isSelected: Bool = false {
        didSet {
            color = isSelected ? selectedColor : defaultColor
            mask.strokeColor = isSelected ? selectedColor : defaultColor
        }
    }
    

    private var defaultColor: UIColor = .systemBlue
    private var selectedColor: UIColor = .systemGray
    private var disabledColor: UIColor = .black
    private var mask: SKShapeNode!
    
    var label: SKLabelNode
    weak var delegate: ButtonProtocol?
    
    
    init(text: String, size: CGSize) {
        
        self.label = SKLabelNode(text: text)
        self.label.fontColor = .white
        self.label.fontName = "SFPro-Bold"
        self.label.verticalAlignmentMode = .center
        self.label.horizontalAlignmentMode = .center
        
        
        super.init(texture: nil, color: defaultColor, size: size)

        self.addChild(label)
        self.isUserInteractionEnabled = true
        self.setupRoundedCorners()
    }
    
    public func adjustLabelFontSizeToFitRect(labelNode:SKLabelNode, rect:CGRect) {
        
        // Determine the font scaling factor that should let the label text fit in the given rectangle.
        let scalingFactor = min(rect.width / labelNode.frame.width, rect.height / (labelNode.frame.height * 2.5))
        
        // Change the fontSize.
        labelNode.fontSize *= scalingFactor
        
        // Optionally move the SKLabelNode to the center of the rectangle.
        //labelNode.position = CGPoint(x: rect.midX, y: rect.midY - labelNode.frame.height / 2.0)
    }
    
    private func setupRoundedCorners() {
        mask = SKShapeNode(rect: CGRect(x: self.position.x - self.size.width / 2,
                                            y: self.position.y - self.size.height / 2,
                                            width: self.size.width,
                                            height: self.size.height),
                               cornerRadius: 3.0)
        mask.strokeColor = self.color
        mask.lineWidth = 2.3
        mask.fillColor = .clear
        self.addChild(mask)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // If button is disabled, do nothing
        if (!isEnabled) {
            return
        }
        isSelected = true
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // If button is enabled, do nothing
        if (!isEnabled) {
            return
        }
        
        let touch: AnyObject! = touches.first
        let touchLocation = touch.location(in: parent!)
        
        // Check to see if button frame still contains touch
        if (frame.contains(touchLocation)) {
            isSelected = true
        } else {
            isSelected = false
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (!isEnabled) {
            return
        }
        
        if isSelected {
            self.delegate?.buttonPressed(sender: self)
        }
        
        isSelected = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
