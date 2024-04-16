//
//  ViewController.swift
//  GameplayKit_Entity_Component Basics
//
//  Created by 신상우 on 2023/04/08.
//

import UIKit
import SceneKit

class GameViewController: UIViewController {
    
    let game = Game()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let scnView = self.view as? SCNView else { fatalError("error") }
        
        scnView.backgroundColor = .lightGray
        
        scnView.scene = game.scene
        
        scnView.delegate = game
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        scnView.addGestureRecognizer(tap)
    }
    
    @objc private func handleTap(_: UITapGestureRecognizer) {
        game.jumpBoxes()
    }
}

