//
//  GameViewController.swift
//  TheEndlessRunner
//
//  Created by Joey Newfield on 1/22/18.
//  Copyright © 2018 Joey Newfield. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController, GameSceneDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.becomeFirstResponder()
        
        let lifetimeScoreDefault = UserDefaults.standard
        if lifetimeScoreDefault.value(forKey: "LifeTimeScore") != nil {
            lifetimeScore = lifetimeScoreDefault.value(forKey: "LifeTimeScore") as! NSInteger
            
        }
        
        /*if let view = self.view as! SKView? {
         // Load the SKScene from 'GameScene.sks'
         if let scene = SKScene(fileNamed: "GameScene") {
         // Set the scale mode to scale to fit the window
         scene.scaleMode = .aspectFill
         
         // Present the scene
         view.presentScene(scene)
         }
         
         view.ignoresSiblingOrder = true
         
         view.showsFPS = true
         view.showsNodeCount = true
         }*/
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if let skView = self.view as? SKView {
            if skView.scene == nil {
                //create scene
                let aspectRatio = skView.bounds.size.height / skView.bounds.size.width
                //let scene = GameScene(size: CGSize(width: 320, height: 320 * aspectRatio))
                let scene = GameScene(size:CGSize(width: 320, height: 320 * aspectRatio), stateClass: MainMenuState.self, delegate: self)
                
                skView.showsFPS = true
                skView.showsNodeCount = true
                skView.showsPhysics = true
                skView.ignoresSiblingOrder = true
                
                scene.scaleMode = .aspectFill
                
                skView.presentScene(scene)
                
            }
        }
    }
    
    func screenshot() {
        //
    }
    
    func sharestring() {
        //
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

