//
//  GameScene.swift
//  MultiState_ScrollingGame_StarterProject
//
//  Created by Craig Anthony on 2/22/17.
//  Copyright © 2017 CASM Group, LLC. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation
import UIKit

//

struct PhysicsCategory {
    static let None: UInt32 =       0       //0
    static let Player: UInt32 =     0b1     //1
    static let Obstacle: UInt32 =   0b10    //2
    static let Ground: UInt32 =     0b100   //4
}

protocol GameSceneDelegate {
    
    //func screenshot() -> UIImage
    //func shareString(_ string: String, url: URL, image: UIImage)
}

//

var hitTop = false
var playing = false
public var movementAllowed = false
public var lifetimeScore = 0

//

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var deltaTime: TimeInterval = 0
    var lastUpdateTimeInterval: TimeInterval = 0
    var playableStart: CGFloat = 0
    var playableHeight: CGFloat = 0
    var margin: CGFloat = 30.0
    let groundSpeed: CGFloat = 100.0
    let backgroundSpeed1: CGFloat = 4.0
    let backgroundSpeed2: CGFloat = 10.0
    
    let worldNode = SKNode()
    var scoreLabel: SKLabelNode!
    var score = 0
    var fontName = "AmericanTypewriter-Bold"
    
    let numberOfBackgrounds = 2
    let numberOfForegrounds = 2
    
    let bottomObstacleMinFraction: CGFloat = 0.1
    let bottomObstacleMaxFraction: CGFloat = 0.6
    
    let firstSpawnDelay: TimeInterval = 2.25
    let everySpawnDelay: TimeInterval = 4.1
    
    let player = Player(imageName: "fatJimmy0")
    
    let popAction = SKAction.playSoundFileNamed("pop.wav", waitForCompletion: false)
    let coinSound = SKAction.playSoundFileNamed("coin.wav", waitForCompletion: false)
    
    let pauseButton = SKSpriteNode(imageNamed: "pauseButton")
    var pausedTracker = 0
    let dimmerSprite = SKSpriteNode(imageNamed: "dimmerSprite")
    
    lazy var gameState: GKStateMachine = GKStateMachine(states: [
        MainMenuState(scene: self),
        InstructionsState(scene: self),
        PlayingState(scene: self),
        FallingState(scene: self),
        GameOverState(scene: self)
        ])

    var initialState: AnyClass
    var gameSceneDelegate: GameSceneDelegate
    
    init(size: CGSize, stateClass: AnyClass, delegate: GameSceneDelegate) {
        gameSceneDelegate = delegate
        initialState = stateClass
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //
    
    override func didMove(to view: SKView) {
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0.0)
        physicsWorld.contactDelegate = self
        addChild(worldNode)
        
        //setupBackground()
        //setupForeground()
        //setupPlayer()
        //setupScoreLabel()
        
        print("pausebutton should be added")
        pauseButton.position = CGPoint(x: size.width * 0.125, y: size.height - (margin * 1.45))
        pauseButton.setScale(1.5)
        pauseButton.zPosition = 10
        pauseButton.name = "pauseButton"
        worldNode.addChild(pauseButton)
        
        gameState.enter(initialState)
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        if lastUpdateTimeInterval == 0 {
            lastUpdateTimeInterval = currentTime
        }
        
        deltaTime = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        
        //after Game State Machine Updates from here on...
        gameState.update(deltaTime: deltaTime)
        
        //Per-Entity updates
        
        player.update(deltaTime: deltaTime)
        
        
        if hitTop == true {
            
            gameState.enter(FallingState.self)
            
        }

        //updateBackground()
        //updateForeground()
    }
    
    func setupBackground() {
        
        let background1 = SKSpriteNode(imageNamed: "Background1")
        
        /*
        background1.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        background1.position = CGPoint(x: size.width / 2, y: size.height)
        background1.zPosition = -10
        worldNode.addChild(background1)
        */
        
        for i in 0..<numberOfBackgrounds {
            let background1 = SKSpriteNode(imageNamed: "Background1")
            background1.anchorPoint = CGPoint(x: 0.0, y: 1.0)
            background1.position = CGPoint(x: CGFloat(i) * size.width, y: size.height)
            background1.zPosition = -10
            background1.name = "background1"
            
            worldNode.addChild(background1)
        }
        
        for i in 0..<numberOfBackgrounds {
            let background2 = SKSpriteNode(imageNamed: "Background2")
            background2.anchorPoint = CGPoint(x: 0.0, y: 1.0)
            background2.position = CGPoint(x: CGFloat(i) * size.width, y: size.height)
            background2.zPosition = -9
            background2.name = "background2"
            
            worldNode.addChild(background2)
        }
    
        //Helps create the physics body so it stops where the foreground begins.
        playableStart = size.height - background1.size.height
        playableHeight = background1.size.height
        let lowerLeft = CGPoint(x: 0, y: playableStart)
        let lowerRight = CGPoint(x: size.width, y: playableStart)
        
        //Add physics body for ground
        physicsBody = SKPhysicsBody(edgeFrom: lowerLeft, to: lowerRight)
        physicsBody?.categoryBitMask = PhysicsCategory.Ground
        physicsBody?.collisionBitMask = 0
        physicsBody?.contactTestBitMask = PhysicsCategory.Player
        
    }
    
    func setupForeground(){
        
        for i in 0..<numberOfForegrounds {
            let foreground = SKSpriteNode(imageNamed: "Ground")
            foreground.anchorPoint = CGPoint(x: 0.0, y: 1.0)
            foreground.position = CGPoint(x: CGFloat(i) * size.width, y: playableStart)
            foreground.zPosition = -5
            foreground.name = "foreground"
            
            worldNode.addChild(foreground)
            
           
        }
    }
    
    func updateBackground() {
        
        worldNode.enumerateChildNodes(withName: "background1", using: { node, stop in
            if let background1 = node as? SKSpriteNode {
                let moveAmount = CGPoint(x: -self.backgroundSpeed1 * CGFloat(self.deltaTime), y: 0)
                background1.position += moveAmount
                
                if background1.position.x < -background1.size.width {
                    background1.position += CGPoint(x: background1.size.width * CGFloat(self.numberOfBackgrounds), y: 0)
                }
            }
        })
        
        worldNode.enumerateChildNodes(withName: "background2", using: { node, stop in
            if let background2 = node as? SKSpriteNode {
                let moveAmount = CGPoint(x: -self.backgroundSpeed2 * CGFloat(self.deltaTime), y: 0)
                background2.position += moveAmount
                
                if background2.position.x < -background2.size.width {
                    background2.position += CGPoint(x: background2.size.width * CGFloat(self.numberOfBackgrounds), y: 0)
                }
            }
        })
    }
    
    func updateForeground(){
        
        worldNode.enumerateChildNodes(withName: "foreground", using: { node, stop in
            if let foreground = node as? SKSpriteNode {
                let moveAmount = CGPoint(x: -self.groundSpeed * CGFloat(self.deltaTime), y: 0)
                foreground.position += moveAmount
                
                if foreground.position.x < -foreground.size.width {
                    foreground.position += CGPoint(x: foreground.size.width * CGFloat(self.numberOfForegrounds), y: 0)
                }
            }
        })
        
    }
    
    func setupPlayer(){
        let playerNode = player.spriteComponent.node
        player.movementComponent.playableHeight = playableHeight + playableStart
        playerNode.position = CGPoint(x: size.width * 0.2, y: playableHeight * 0.0 + playableStart + playerNode.size.height / 2)
        playerNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        playerNode.setScale(0.75)
        playerNode.zPosition = 10
        
        worldNode.addChild(playerNode)
    }
    
    func setupScoreLabel(){
        scoreLabel = SKLabelNode(fontNamed: fontName)
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height - margin)
        scoreLabel.verticalAlignmentMode = .center
        scoreLabel.zPosition = 11
        
        scoreLabel.text = "\(score)"
        worldNode.addChild(scoreLabel)
    }
    
    func initialJimmyScaleUp() {
        
        self.player.spriteComponent.node.run(SKAction.scale(to: 1.2, duration: 0.5))
        player.spriteComponent.node.run(SKAction.rotate(toAngle: 3.1459 * 2.0, duration: 0.5))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first{
            
            let touchLocation = touch.location(in: self)
            let touchedNode = self.atPoint(touchLocation)
            
            
            if touchedNode.name == "pauseButton" && pausedTracker == 0  {
                
                dimScreen()
                pauseButton.texture = SKTexture(imageNamed: "playButton")
                
                movementAllowed = false
                pausedTracker = 1
                //backgroundMusicPlayer.pause()
                
                let wait = SKAction.wait(forDuration: 0.05)
                let block = SKAction.run({
                    self.isPaused = true
                    self.scene?.view?.isPaused = true
                })
                run(SKAction.sequence([wait, block]))
                
            } else if touchedNode.name == "pauseButton" && pausedTracker == 1  {
                
                self.isPaused = false
                self.scene?.view?.isPaused = false
                pauseButton.texture = SKTexture(imageNamed: "pauseButton")
                //backgroundMusicPlayer.play()
                removeDimmer()
                pausedTracker = 0
                
                let wait = SKAction.wait(forDuration: 0.05)
                let block = SKAction.run({
                    movementAllowed = true
                })
                run(SKAction.sequence([wait, block]))
                
            }
            
            
            switch gameState.currentState {
            case is MainMenuState:
                
                if touchLocation.x < size.width * 0.6 && touchLocation.y > size.height * 0.55 &&  touchLocation.y < size.height * 0.65 {
                    restartGame(InstructionsState.self)
                } else if touchLocation.x > size.width * 0.6 && touchLocation.y > size.height * 0.55 && touchLocation.y < size.height * 0.65 {
                    //rateApp()
                }
            case is InstructionsState:
                
                if touchLocation.y > playableStart  {
                    
                    gameState.enter(PlayingState.self)
                    
                }
            case is PlayingState:
                player.movementComponent.applyImpulse(lastUpdateTimeInterval)
            case is GameOverState:
                
                if touchLocation.x < size.width * 0.6 && touchLocation.y > size.height * 0.38 && touchLocation.y < size.height * 0.48 {
                    restartGame(InstructionsState.self)
                } else if touchLocation.x > size.width * 0.6 && touchLocation.y > size.height * 0.38 && touchLocation.y < size.height * 0.48 {
                    //shareScore()
                } else if touchLocation.x > size.width * 0.6 && touchLocation.y > size.height * 0.27 && touchLocation.y < size.height * 0.37 {
                    //rateApp()
                }
            default:
                break
            }
        }
    }
    
    func dimScreen() {
        
        dimmerSprite.setScale(2.0)
        dimmerSprite.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        dimmerSprite.position = CGPoint(x: size.width / 2, y: size.height)
        dimmerSprite.zPosition = 0
        dimmerSprite.alpha = 0.15
        worldNode.addChild(dimmerSprite)
        
    }
    
    func removeDimmer() {
        
        dimmerSprite.removeFromParent()
    }
    
    func restartGame(_ stateClass: AnyClass) {
        run(popAction)
        
        let newScene = GameScene(size: size, stateClass: stateClass, delegate: gameSceneDelegate)
        let transition = SKTransition.fade(with: SKColor.black, duration: 0.05)
        view?.presentScene(newScene, transition: transition)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contact = contact.bodyA.categoryBitMask == PhysicsCategory.Player ? contact.bodyB : contact.bodyA
        
        if contact.categoryBitMask == PhysicsCategory.Ground {
            print("hit ground without falling")
            gameState.enter(GameOverState.self)
        }
        if contact.categoryBitMask == PhysicsCategory.Obstacle {
            print("hit obstacle")
            gameState.enter(FallingState.self)
            print("entered FallingState")
        }
        
    }
    
    func createObstacle() -> SKSpriteNode {
        
        let obstacle = Obstacle(imageName: "carrot")
        let obstacleNode = obstacle.spriteComponent.node
        obstacleNode.zPosition = -6
        
        obstacleNode.name = "obstacle"
        obstacleNode.userData = NSMutableDictionary()
        
        return obstacle.spriteComponent.node
    }
    
    func spawnObstacle() {
        
        let bottomObstacle = createObstacle()
        let startX = size.width + bottomObstacle.size.width / 2
        
        let bottomObstacleMin = (playableStart - bottomObstacle.size.height / 2) + playableHeight * bottomObstacleMinFraction
        let bottomObstacleMax = (playableStart - bottomObstacle.size.height / 2) + playableHeight * bottomObstacleMaxFraction
        
        let randomSource = GKARC4RandomSource()
        let randomDistribution = GKRandomDistribution(randomSource: randomSource, lowestValue: Int(round(bottomObstacleMin)), highestValue: Int(round(bottomObstacleMax)))
        let randomValue = randomDistribution.nextInt()
        
        bottomObstacle.position = CGPoint(x: startX, y: CGFloat(randomValue))
        worldNode.addChild(bottomObstacle)
        
        let moveX = size.width + bottomObstacle.size.width
        let moveDuration = moveX / groundSpeed
        
        let sequence = SKAction.sequence([
            SKAction.moveBy(x: -moveX, y: 0, duration: TimeInterval(moveDuration)),
            SKAction.removeFromParent()
            ])
        
        bottomObstacle.run(sequence)
    }
    
    func startSpawningObstacle() {
        
        let firstDelay = SKAction.wait(forDuration: firstSpawnDelay)
        let spawn = SKAction.run(spawnObstacle)
        let everyDelay = SKAction.wait(forDuration: everySpawnDelay)
        
        let spawnSequence = SKAction.sequence([spawn, everyDelay])
        let foreverSpawn = SKAction.repeatForever(spawnSequence)
        let overallSequence = SKAction.sequence([firstDelay, foreverSpawn])
        
        run(overallSequence, withKey: "spawn")
    }
    
    func stopSpawningObstacle() {
        removeAction(forKey: "spawn")
        worldNode.enumerateChildNodes(withName: "obstacle", using: { node, stop in
            node.removeAllActions()
        })
    }
    
    func updateScoreLabel() {
        worldNode.enumerateChildNodes(withName: "obstacle", using: { node, stop in
            if let obstacle = node as? SKSpriteNode {
                if let passed = obstacle.userData?["Passed"] as? NSNumber {
                    if passed.boolValue {
                        return
                    }
                }
                if self.player.spriteComponent.node.position.x > obstacle.position.x + obstacle.size.width / 2 {
                    self.score = self.score + 10
                    self.scoreLabel.text = "\(self.score / 1)"
                    
                    obstacle.userData?["Passed"] = NSNumber(value: true)
                    self.run(self.coinSound)
                    
                    let scaleUp = SKAction.scale(to: 1.5, duration: 0.05)
                    let scaleDown = SKAction.scale(to: 1.0, duration: 0.05)
                    let sequence = SKAction.sequence([scaleUp, scaleDown])
                    
                    self.scoreLabel.fontColor = SKColor.purple
                    self.scoreLabel.run(sequence)
                    
                    let wait = SKAction.wait(forDuration: 0.1)
                    let returnToWhite = SKAction.run({
                        
                        self.scoreLabel.fontColor = SKColor.white
                        
                    })
                    
                    let sequence2 = SKAction.sequence([wait, returnToWhite])
                    self.scoreLabel.run(sequence2)
                    
                }
            }
        })
    }


    
    
}
