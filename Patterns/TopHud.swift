//
//  TopHud.swift
//  Patterns
//
//  Created by Drew Brokamp on 12/13/20.
//  Copyright © 2020 Drew Brokamp. All rights reserved.
//

import SpriteKit

class TopHud: Hud {
    
    private var actionButton: Button!
    
    override init(size: CGSize) {
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
