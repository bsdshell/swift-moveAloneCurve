//
//  GameScene.swift
//  swift-moveAloneCurve
//
//  Created by aaa on 2024-08-22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let e0 = CGPoint(x:0, y:500)
        let e1 = CGPoint(x:0, y:100)
        let c0 = CGPoint(x:300, y:300)
        let c1 = CGPoint(x:300, y:200)
        
        let ex0 = CGPoint(x:0, y:-200)
        let cx0 = CGPoint(x:-300, y:0)
        let cx1 = CGPoint(x:-300, y:-100)
                
        let cir0 = Ball(position: e0, radius: 15.0)
        cir0.draw()
        cir0.fillColor = UIColor.green
        self.addChild(cir0.getNode())

        let cir1 = Ball(position: e1, radius: 15.0)
        cir1.draw()
        cir1.fillColor = UIColor.red
        self.addChild(cir1.getNode())

        let cir2 = Ball(position: c0, radius: 10.0)
        cir2.draw()
        cir2.fillColor = UIColor.blue
        self.addChild(cir2.getNode())

        let cir3 = Ball(position: c1, radius: 10.0)
        cir3.draw()
        cir3.fillColor = UIColor.yellow
        self.addChild(cir3.getNode())

        let cir4 = Ball(position: ex0, radius: 15.0)
        cir4.draw()
        cir4.fillColor = UIColor.brown
        self.addChild(cir4.getNode())

        let cir5 = Ball(position: cx0, radius: 10.0)
        cir5.draw()
        cir5.fillColor = UIColor.gray
        self.addChild(cir5.getNode())

        let cir6 = Ball(position: cx1, radius: 10.0)
        cir6.draw()
        cir6.fillColor = UIColor.cyan
        self.addChild(cir6.getNode())
        
        let imgName =  "dropbomb4_x.png"
        let missle = SKSpriteNode(imageNamed: imgName)
        missle.size = CGSize(width: 40, height: 40)
        // missle.zRotation = CGFloat.pi
        

        
        let path = UIBezierPath()
        path.move(to: e0)
        path.addCurve(to:e1,
                      controlPoint1: c0,
                      controlPoint2: c1)
        
        let tran = CGAffineTransform.init(a:-1, b:0, c:0, d:1, tx:0, ty:0)
        
        // let path1 = UIBezierPath()
        // path1.move(to: CGPoint(x: 0,y: 100))
        path.addCurve(to:ex0,
                      controlPoint1: cx0,
                      controlPoint2: cx1)
        
        // use the beizer path in an action
        // path.apply(tran)

        let rmit = SKAction.removeFromParent()
        let follow = SKAction.follow(path.cgPath,
                                     asOffset: false,
                                     orientToPath: true,
                                     speed: 200.0)
        
        // missle.run(SKAction.sequence([follow, rmit]))
        missle.run(SKAction.repeatForever(follow))
        // missle.run(SKAction.repeatForever(follow).reversed())
        self.addChild(missle)
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
