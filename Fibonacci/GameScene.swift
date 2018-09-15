//
//  GameScene.swift
//  Fibonacci
//
//  Created by Gerben de Graaf on 14/09/2018.
//  Copyright © 2018 Gerben de Graaf. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var button : SKSpriteNode?
    private var startY : CGFloat = 0.0
    
    private let numberFormatter = NumberFormatter()
    private var minStep : CGFloat = 0.0
    let shortFadeIn = SKAction.fadeAlpha(to: 1.0, duration: 0.2)
    let shortFadeOut = SKAction.fadeAlpha(to: 0.5, duration: 0.2)
    let shortScaleUp = SKAction.scale(to: 1.0, duration: 0.1)
    let shortScaleDown = SKAction.scale(to: 0.7, duration: 0.1)

    private var animationRunning : Bool = false
    private var currentValue : Int = 3
    
    override func sceneDidLoad() {

        self.lastUpdateTime = 0
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//countLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 1.0))
        }
        
        //NSLog(size.height.description)
        
//        // Create shape node to use during mouse interaction
//        let w = (self.size.width + self.size.height) * 0.05
//        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
//
//        if let spinnyNode = self.spinnyNode {
//            spinnyNode.lineWidth = 2.5
//
//            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
//            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
//                                              SKAction.fadeOut(withDuration: 0.5),
//                                              SKAction.removeFromParent()]))
//        }
        //        Eightball.image = UIImage(named: "ball\(randomIndex)")
        button = SKSpriteNode(imageNamed: "aqua-button")
        // Put it in the center of the scene
//        let midY = (self.view?.frame.height)! / 2
//        let midX = (self.view?.frame.width)! / 2
        button!.position = CGPoint(x:300, y:300);
        
        self.addChild(button!)
        let maxValue = size.height / 2
        self.minStep = maxValue / 7
        

    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        // ☕️, ?, 0, 1/2, 1, 2, 3, 5, 8, 13, 21, 40
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if (!animationRunning) {
            var numValue = 3;
            var playValue = "3"
            if (pos.y > 0) {
                // determine scaling
                if (pos.y*1 > self.minStep*6) {
                    playValue = "☕️"
                } else if (pos.y*1 > self.minStep*5) {
                    playValue = "?"
                } else if (pos.y*1 > self.minStep*4) {
                    playValue = "0"
                } else if (pos.y*1 > self.minStep*3) {
                    playValue = "1/2"
                } else if (pos.y*1 > self.minStep*2) {
                    playValue = "1"
                } else if (pos.y*1 > self.minStep*1) {
                    playValue = "2"
                }
            } else if (pos.y < 0) {
                if (pos.y < self.minStep * -6) {
                    playValue = "40"
                } else if (pos.y < self.minStep * -5) {
                    playValue = "21"
                } else if (pos.y < self.minStep * -4) {
                    playValue = "13"
                } else if (pos.y < self.minStep * -3) {
                    playValue = "8"
                } else if (pos.y < self.minStep * -2) {
                    playValue = "5"
                } else {
                    playValue = "3"
                }
            }
            self.label?.text = playValue
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
//        if (numValue != currentValue) {
//            var seq : [SKAction] = []
//            seq.append(SKAction.run({
//                self.animationRunning = true
//            }))
//            while (numValue > currentValue) {
//                numValue = numValue - 1
//                seq.append(SKAction.run({
//                    self.label?.text = String(numValue)
//                    SKAction.wait(forDuration: 0.05)
//                }))
//                NSLog("\(numValue)")
//            }
//            while (numValue < currentValue) {
//                numValue = numValue + 1
//                seq.append(SKAction.run({
//                    self.label?.text = String(numValue)
//                    SKAction.wait(forDuration: 0.05)
//                }))
//            }
//            seq.append(SKAction.run({
//                self.label?.text = playValue
//                self.animationRunning = false
//            }))
//            label?.run(SKAction.sequence(seq))
//        }
        label?.run(self.shortFadeIn)
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.red
//            self.addChild(n)
//        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.animationRunning = true
        let touch = touches.first!
        let location = touch.location(in: self)
        startY = location.y
        let finished = SKAction.run({
           self.animationRunning = false
        })
        label?.run(SKAction.sequence([shortScaleDown, shortFadeOut, finished]))
//        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        label?.run(SKAction.sequence([shortScaleUp, shortFadeIn]))
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
}
