//
//  PlayingPatternState.swift
//  Patterns
//
//  Created by Drew Brokamp on 12/13/20.
//  Copyright © 2020 Drew Brokamp. All rights reserved.
//

import GameplayKit

class PlayingPatternState: GKState {
    
    private weak var scene: GameScene?
    
    init(scene: GameScene) {
        
        self.scene = scene
        super.init()
        
    }
    
}
