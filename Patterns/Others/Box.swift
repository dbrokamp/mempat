//
//  ButtonNode.swift
//  Patterns
//
//  Created by Drew Brokamp on 8/31/19.
//  Copyright © 2019 Drew Brokamp. All rights reserved.
//
//  Set Action Example:
//  moreHealthRewardButton.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(GameScene.startRewardAd))
//
//  @objc func startRewardAd() {
//    if rewardBasedVideo?.isReady == true {
//        rewardBasedVideo?.present(fromRootViewController: (self.view?.window?.rootViewController)!)
//    } else {
//        moreHealthRewardButton.setButtonLabel(title: "Ad failed to load", font: "Krungthep", fontSize: 10.0)
//        moreHealthRewardButton.adjustLabelFontSizeToFitRect(labelNode: moreHealthRewardButton.label, rect: moreHealthRewardButton.frame)
//    }
//  }


import SpriteKit

class Box: SKSpriteNode {

    enum FTButtonActionType: Int {
        case TouchUpInside = 1,
        TouchDown, TouchUp
    }

    var isEnabled: Bool = true {
        didSet {
            if (disabledTexture != nil) {
                color = (isEnabled ? defaultTexture : disabledTexture) ?? .white
            }
        }
    }
    var isSelected: Bool = false {
        didSet {
            color = isSelected ? selectedTexture : defaultTexture
        }
    }

    var defaultTexture: UIColor
    var selectedTexture: UIColor
    var label: SKLabelNode

    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    init(boxSize: CGSize, defaultTexture: UIColor, selectedTexture: UIColor, disabledTexture: UIColor?) {

        self.defaultTexture = defaultTexture
        self.selectedTexture = selectedTexture
        self.disabledTexture = disabledTexture
        self.label = SKLabelNode(fontNamed: "Helvetica");

        super.init(texture: nil, color: UIColor.clear, size: boxSize)
        isUserInteractionEnabled = true
        color = defaultTexture

        //Creating and adding a blank label, centered on the button



    }

    /**
     * Taking a target object and adding an action that is triggered by a button event.
     */
    func setButtonAction(target: AnyObject, triggerEvent event:FTButtonActionType, action:Selector) {

        switch (event) {
        case .TouchUpInside:
            targetTouchUpInside = target
            actionTouchUpInside = action
        case .TouchDown:
            targetTouchDown = target
            actionTouchDown = action
        case .TouchUp:
            targetTouchUp = target
            actionTouchUp = action
        }

    }

    /*
     New function for setting text. Calling function multiple times does
     not create a ton of new labels, just updates existing label.
     You can set the title, font type and font size with this function
     */

    func setButtonLabel(title: String, font: String, fontSize: CGFloat) {
        self.label.text = title as String
        self.label.fontSize = fontSize
        self.label.fontName = font
        self.label.fontColor = .americanRiver
        self.label.zPosition = 150.0
        self.label.verticalAlignmentMode = .center
        self.label.horizontalAlignmentMode = .center
        self.addChild(self.label)
    }

    var disabledTexture: UIColor?
    var actionTouchUpInside: Selector?
    var actionTouchUp: Selector?
    var actionTouchDown: Selector?
    weak var targetTouchUpInside: AnyObject?
    weak var targetTouchUp: AnyObject?
    weak var targetTouchDown: AnyObject?

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (!isEnabled) {
            return
        }
        isSelected = true
        if (targetTouchDown != nil && targetTouchDown!.responds(to: actionTouchDown)) {
            UIApplication.shared.sendAction(actionTouchDown!, to: targetTouchDown, from: self, for: nil)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        if (!isEnabled) {
            return
        }

        let touch: AnyObject! = touches.first
        let touchLocation = touch.location(in: parent!)

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

        isSelected = false

        if (targetTouchUpInside != nil && targetTouchUpInside!.responds(to: actionTouchUpInside!)) {
            let touch: AnyObject! = touches.first
            let touchLocation = touch.location(in: parent!)

            if (frame.contains(touchLocation) ) {
                UIApplication.shared.sendAction(actionTouchUpInside!, to: targetTouchUpInside, from: self, for: nil)
            }

        }

        if (targetTouchUp != nil && targetTouchUp!.responds(to: actionTouchUp!)) {
            UIApplication.shared.sendAction(actionTouchUp!, to: targetTouchUp, from: self, for: nil)
        }
    }

}



