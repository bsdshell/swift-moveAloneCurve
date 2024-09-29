//
//  GameScene.swift
//  swift-moveAloneCurve
//
//  Created by aaa on 2024-08-22.
//

import SpriteKit
import GameplayKit


/*
extension SKNode
{
    func addGlow(radius:CGFloat=30)
    {
        let view = SKView()
        let effectNode = SKEffectNode()
        let texture = view.texture(from: self)
        effectNode.shouldRasterize = true
        effectNode.filter = CIFilter(name: "CIGaussianBlur",parameters: ["inputRadius":radius])
        addChild(effectNode)
        effectNode.addChild(SKSpriteNode(texture: texture))
    }
}
 */

extension SKSpriteNode {

    func addGlow(radius: Float = 30) {
        let effectNode = SKEffectNode()
        effectNode.shouldRasterize = true
        addChild(effectNode)
        let effect = SKSpriteNode(texture: texture)
        effect.color = .white
        effect.colorBlendFactor = 1
        effectNode.addChild(effect)
        effectNode.filter = CIFilter(name: "CIGaussianBlur", parameters: ["inputRadius":radius])
    }
}

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    private var frameMarginW : CGFloat = 0.8
    private var frameMarginH : CGFloat = 0.9
    private var topLeft : CGPoint = CGPoint(x:0, y:0)
    private var gameSize : CGSize = CGSize(width: 0.0, height: 0.0)
    private var bottomRight : CGPoint = CGPoint(x:0, y:0)
    
    private var initTime0 : TimeInterval = -10.0
    private var initTime1 : TimeInterval = -10.0
    private var initTime2 : TimeInterval = -10.0
    private var rotFlag : Bool = true
    private var bulletSet : Set<String> = []
    private var bulletCount : Int = 0
    private var bulletHeight : CGFloat = 500.0
    
    override func didMove(to view: SKView) {
        
        // Get label node from scene and store it for use later
        /*
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
        */
    }

    
    func randomTwoPts(dt:CGFloat) -> (CGPoint, CGPoint){
        var done = true
        var ret : (CGPoint, CGPoint) = (CGPoint(x:0, y:0), CGPoint(x:0, y:0))
        while done {
            var ls :[CGPoint] = []
            for n in 0...4{
                let pt = randomPtRect(topLeft: self.topLeft, width: self.gameSize.width, height: gameSize.height)
                ls.append(pt)
            }
            let lv = combine(num:2, list:ls)
            for lt in lv{
                let d = dist(vec: lt[0] - lt[1])
                if d >= dt{
                    ret = (lt[0], lt[1])
                    done = false
                }
            }
        }
        return ret
    }
    
    func randomTwoPts(topLeft:CGPoint, width:CGFloat, height:CGFloat, dt:CGFloat) -> (CGPoint, CGPoint){
        var done = true
        var ret : (CGPoint, CGPoint) = (CGPoint(x:0, y:0), CGPoint(x:0, y:0))
        while done {
            var ls :[CGPoint] = []
            for n in 0...4{
                let pt = randomPtRect(topLeft:topLeft, width:width, height:height)
                ls.append(pt)
            }
            let lv = combine(num:2, list:ls)
            for lt in lv{
                let d = dist(vec: lt[0] - lt[1])
                if d >= dt{
                    ret = (lt[0], lt[1])
                    done = false
                }
                
            }
        }
        return ret
    }

    func randomPtRect(topLeft:CGPoint, width:CGFloat, height:CGFloat) -> CGPoint{
        let rx = CGFloat.random(in: 0...1.0)
        let ry = CGFloat.random(in: 0...1.0)
        return CGPoint(x : topLeft.x + width * rx, y : topLeft.y - height * ry)
    }
    
    func randomPairPt(e0:CGPoint, e1:CGPoint, width:CGFloat) -> (CGPoint, CGPoint){
        let h = abs(e1.y - e0.y)
        let c0 = randomPtRect(topLeft:CGPoint(x:e0.x - width/2, y:e0.y), width: width, height:h)
        let c1 = randomPtRect(topLeft:CGPoint(x:e0.x - width/2, y:e0.y), width: width, height:h)
        return (c0, c1)
    }

    func circlePath(e0:CGPoint, e1:CGPoint, width:CGFloat) -> UIBezierPath{
        let w = self.size.width * frameMarginW
        let h = self.size.height * frameMarginH
        
        let path = UIBezierPath()
        let (x0, x1) = randomTwoPts(dt: 900)
  
        let cirx = Circle(position: x0, radius: 15.0)
        cirx.fillColor = UIColor.green
        self.addChild(cirx.getNode())

        let ciry = Circle(position: x1, radius: 15.0)
        ciry.fillColor = UIColor.red
        self.addChild(ciry.getNode())
        
        let cc0 = randomPtRect(topLeft: CGPoint(x:-w/2,y:h/2), width: w, height: h/2)
        let cc1 = randomPtRect(topLeft: CGPoint(x:-w/2,y:h/2), width: w, height: h/2)

        let cxx0 = Circle(position: cc0, radius: 15.0)
        cxx0.setColor(color:UIColor.cyan)
        self.addChild(cxx0.getNode())

        let cxx1 = Circle(position: cc1, radius: 15.0)
        cxx1.setColor(color:UIColor.red)
        self.addChild(cxx1.getNode())
        
        path.move(to:x0)
        path.addCurve(to:x1,
                      controlPoint1: cc0,
                      controlPoint2: cc1)
        let (x2, x3) = randomTwoPts(dt: 900)
        
        let a0 = Circle(position: x2, radius: 20.0)
        a0.setColor(color:UIColor.red)
        self.addChild(a0.getNode())
        
        let a1 = Circle(position: x3, radius: 20.0)
        a1.setColor(color:UIColor.yellow)
        self.addChild(a1.getNode())
        
        path.addCurve(to:x0,
                      controlPoint1: x2,
                      controlPoint2: x3)

        return path
    }

    func rotMatCW(ang:CGFloat, vec:CGVector) -> CGVector{
        let c11 = cos(ang)
        let c21 = sin(ang)
        let c12 = -sin(ang)
        let c22 = cos(ang)
        let col1 = simd_double2(x:c11, y:c21)
        let col2 = simd_double2(x:c21, y:c22)
        
        let mat = simd_double2x2([col1, col2])
        let vec0 = simd_double2(vec.dx, vec.dy)
        let vec1 = simd_mul(mat, vec0)
        print("mat => \(mat)")
        print("vec0 => \(vec0)")
        print("vec1 => \(vec1)")
        return CGVector(dx:vec1[0], dy:vec1[1])
    }

    func randomImg(imgNames:[String]) -> String{
        let inx = Int.random(in:0...(imgNames.count - 1))
        return imgNames[inx]
    }
    
    func createShootNodeAngXAxis(pos:CGPoint, ang:CGFloat, imgNames: [String]) -> SKNode{
        let vec = CGVector(dx:pos.x + 1.0, dy:pos.y)
        let v0 = rotMatCW(ang:ang, vec:vec)
        print("ang => \(ang) v0 => \(v0)")
        return createShootNodeVec(pos:pos, vector:v0, imgNames:imgNames)
    }
    
    func createShootNodePt(pos:CGPoint, pt:CGPoint, imgNames: [String]) -> SKNode{
        let v0 = vec(pt0:pos, pt1:pt)
        return createShootNodeVec(pos:pos, vector:v0, imgNames:imgNames)
    }
    
    func createShootNodeVec(pos:CGPoint, vector:CGVector, imgNames:[String]) -> SKNode{
        let imgName = randomImg(imgNames:imgNames)
        let bulletNode = SKSpriteNode(imageNamed: imgName)
        bulletNode.size = CGSize(width:40, height:40)
        bulletNode.position = pos
        let duraFall = 20.4
        let waitTime = 20.4
        let pt1 = CGPointMake(pos.x, bulletHeight)
        let v0 = vec(pt0: pos, pt1: CGPoint(x:pos.x + 1, y:pos.y))
        let vr = normalize(vec:vector)
        let closure = {
            print("closure")
        }

        let p0 = pos + vector
        let p1 = pos
        let p2 = CGPoint(x:pos.x, y:pos.y + 1.0)
        let angle = cosVex3(pt0:p0, pt1:p1, pt2:p2)
        var distLen = 1000.0
        let dx = dot2(v0:vector, v1:CGVector(dx:0, dy:1.0))
        /*
        if dx == 0.0{
            distLen = p0.x > 0 ? abs(frame.width/2 - p1.x) : abs(-frame.width/2 - p1.x)
        }else{
            distLen = abs((frame.width/2 - p1.x)/cos(angle))
        }
        */

        let shoot = SKAction.move(to:pos + distLen*vr, duration:duraFall)
        print("angle => \(angle)")
        print("dx =>    \(dx)")
        print("distLen => \(distLen)")
        print("distLen * vr => \(distLen * vr)")
        print("frame => \(frame)")
        print("frame.width  => \(frame.width)")
        print("frame.height => \(frame.height)")
        // let rot = CGAffineTransform.init(a:cos(ang), b:sin(ang), c:-sin(ang), d:cos(ang), tx:0, ty:0)
        if p0.x > p1.x{
            bulletNode.zRotation = 2*CGFloat.pi - angle
        }else {
            bulletNode.zRotation = angle
        }

        /*                      |------------------ CGAffineTransformComponents ----------------|
         *
         *      | a  b  0 |     | sx  0  0 |   |  1  0  0 |   | cos(t)  sin(t)  0 |   | 1  0  0 |
         *      | c  d  0 |  =  |  0 sy  0 | * | sh  1  0 | * |-sin(t)  cos(t)  0 | * | 0  1  0 |
         *      | tx ty 1 |     |  0  0  1 |   |  0  0  1 |   |   0       0     1 |   | tx ty 1 |
         *  CGAffineTransform      scale           shear            rotation          translation
         */

        // let sequ = SKAction.sequence([shootSound, fallDown, SKAction.wait(forDuration:waitTime), SKAction.run {
        let runGroup = SKAction.group([shoot])
        
        bulletNode.run(runGroup, completion: closure)

        return bulletNode
    }

    
    func bossPath(e0:CGPoint, e1:CGPoint, width:CGFloat) -> UIBezierPath{
        let w = self.size.width * frameMarginW
        let h = self.size.height * frameMarginH
        
        let path = UIBezierPath()
        // let (x0, x1) = randomTwoPts(dt: 400)
        let x0 = randomPtRect(topLeft: CGPoint(x:-w/2,y:h/2), width: w, height: h/2)
        let x1 = randomPtRect(topLeft: CGPoint(x:-w/2,y:h/2), width: w, height: h/2)

        
        let cirx = Circle(position: x0, radius: 15.0)
        cirx.fillColor = UIColor.red
        self.addChild(cirx.getNode())

        
        let ciry = Circle(position: x1, radius: 15.0)
        ciry.fillColor = UIColor.green
        self.addChild(ciry.getNode())

        
        let cc0 = randomPtRect(topLeft: CGPoint(x:-w/2,y:h/2), width: w, height: h/2)
        let cc1 = randomPtRect(topLeft: CGPoint(x:-w/2,y:h/2), width: w, height: h/2)

        path.move(to:x0)
        path.addCurve(to:x1,
                      controlPoint1: cc0,
                      controlPoint2: cc1)

        for _ in 0...10{
            // var x2 = randomPt(x : -400...400, y:0...400)
            let topLeftx = CGPoint(x:-w/2, y:h/2)
            var x2 = randomPtRect(topLeft: topLeftx, width: w, height: h/2)
            
            var a0 = Circle(position: x2, radius: 15.0)
            a0.setColor(color:UIColor.red)
            self.addChild(a0.getNode())
            
            // var (cc2, cc3) = randomTwoPts(dt: 500)
            var cc2 = randomPtRect(topLeft:topLeftx , width: w, height: h/2)
            var cc3 = randomPtRect(topLeft: topLeftx, width: w, height: h/2)

            var cx0 = Circle(position: cc2, radius: 10.0)
            cx0.setColor(color:UIColor.gray)
            self.addChild(cx0.getNode())
            
            var cx1 = Circle(position: cc3, radius: 10.0)
            cx1.setColor(color:UIColor.darkGray)
            self.addChild(cx1.getNode())
            
            path.addCurve(to:x2,
                          controlPoint1:cc2,
                          controlPoint2:cc3)
        }
        
        /*
        let (x2, x3) = randomTwoPts(dt: 900)
        
        let a0 = Circle(position: x2, radius: 20.0)
        a0.setColor(color:UIColor.red)
        self.addChild(a0.getNode())
        
        let a1 = Circle(position: x3, radius: 20.0)
        a1.setColor(color:UIColor.yellow)
        self.addChild(a1.getNode())
        
        path.addCurve(to:x0,
                      controlPoint1: x2,
                      controlPoint2: x3)
        */
        return path
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let w = self.size.width * frameMarginW
        let h = self.size.height * frameMarginH
        gameSize = CGSize(width: w, height: h)
        
        topLeft = CGPoint(x : 0 - gameSize.width/2, y: gameSize.height/2)
        bottomRight = CGPoint(x : 0 + gameSize.width/2, y : 0 - gameSize.height/2)
        // powerTopLeft = topLeft + CGPoint(x:40, y:-40)

        let e0 = CGPoint(x:0, y:h/2)
        let e1 = CGPoint(x:0, y:0)
        let path = UIBezierPath()

        path.move(to:e0)
        path.addCurve(to:e1,
                      controlPoint1: e0,
                      controlPoint2: e1)
        
        let tran = CGAffineTransform.init(a:-1, b:0, c:0, d:1, tx:0, ty:0)
        
        // let path1 = UIBezierPath()
        // use the beizer path in an action
        // path.apply(tran)
        let circle0 = SKSpriteNode(imageNamed: "circle9.png")
        circle0.size = CGSize(width: 80, height: 80)
        circle0.position = e0
        circle0.addGlow(radius: 30.0)
        
        // let imgName =  "dropbomb4_x.png"
        let imgName = "boss2_x.png"
        // let imgName = "spaceShips_008.png"
        // let imgName = "plane4.png"
        let missle = SKSpriteNode(imageNamed: imgName)
        missle.size = CGSize(width: 80, height: 80)
        missle.name = "rot"
        // let rot = SKAction.rotate(byAngle: 3.14, duration: 20.0)
        // let rmIt = SKAction.removeFromParent()
        // missle.run(SKAction.sequence([rot]))
        
        // Load the shader
        
        let g = SKShader(fileNamed: "GlowShader.fsh")
        circle0.shader = g
        circle0.blendMode = .alpha
        circle0.addGlow(radius: 0.2)
        
        /*
        if let glowShader = SKShader(fileNamed: "GlowShader.fsh") {
            missle.shader = glowShader
            
            // Optionally set the shader's uniforms
            glowShader.uniforms = [
                SKUniform(name: "color", vectorFloat4: vector_float4(1.0, 1.0, 1.0, 1.0))
            ]
        }
         */

        let rmit = SKAction.removeFromParent()
        let follow = SKAction.follow(path.cgPath,
                                     asOffset: false,
                                     orientToPath: true,
                                     speed: 200.0)
        
        // missle.run(SKAction.sequence([follow, rmit]))
        // missle.run(SKAction.repeatForever(follow))
        // missle.run(SKAction.repeatForever(follow).reversed())
        // circle0.run(SKAction.repeatForever(follow).reversed())
        self.addChild(missle)
        // self.addChild(circle0)

        let pos = CGPoint(x:100, y:100)
        let ang = 0.0 // CGFloat.pi/2

        let p0 = CGPoint(x:1.0,  y:1.0)
        let p1 = CGPoint(x:0.0,  y:1.0)
        let p2 = CGPoint(x:-1.0, y:1.0)
        let p3 = CGPoint(x:1.0,  y:0.0)
        let p4 = CGPoint(x:-1.0, y:0.0)
        let p5 = CGPoint(x:0.0,  y:-1.0)

        // func randomPtRect(topLeft:CGPoint, width:CGFloat, height:CGFloat) -> CGPoint{
        let ls = randomPtRectList(topLeft:CGPoint(x:-100, y:500), width:400, height:800, count:5)
        
        // for pt in [p0, p1, p2, p3, p4, p5]{
        // for ang in [0.0, CGFloat.pi/4, CGFloat.pi/2, CGFloat.pi*3/4, CGFloat.pi]{
        // for pt in [CGPoint(x:1, y:0), CGPoint(x:0, y:1), CGPoint(x:1, y:1)]{
        for pt in ls {
            // let vec0 = vec(pt0:pos, pt1:pos + pt)
            // let node = createShootNodeVec(pos:pos, vector:vec0, imgName : "bullet1.png")
            let node = createShootNodePt(pos:pos, pt:pt, imgNames : ["bullet1.png"])
            let name = "b" + String(bulletCount)
            node.name = name
            self.bulletSet.insert(node.name!)
            self.bulletCount += 1
            self.addChild(node)
        }


        let many_rock_0 = SKSpriteNode(imageNamed: "many_rock_0.png")
        many_rock_0.size = CGSize(width: 200, height: 800)
        many_rock_0.position = CGPoint(x:200, y:0)
        self.addChild(many_rock_0)
        

        /*
        var yourline = SKShapeNode()
        var pathToDraw = CGMutablePath()
        pathToDraw.move(to: CGPoint(x:0.0, y:0.0))
        pathToDraw.addLine(to: CGPoint(x:100.0, y:100.0))
        yourline.path = pathToDraw
        yourline.strokeColor = SKColor.red

        let rotL = SKAction.rotate(byAngle: 2*CGFloat.pi, duration: 10.0)
        let rmL  = SKAction.removeFromParent()
        yourline.run(SKAction.sequence([rotL]))
        yourline.zPosition = 1
        addChild(yourline)

        let cir = Circle(position:pos, radius:(2*100.0 * 100.0).squareRoot())
        cir.draw()
        addChild(cir.getNode())
        */


        
    }

    /*
    func addCurve(e0:CGPoint, e1:CGPoint, c0:CGPoint, c1:CGPoint) -> SKShapeNode{
        let path = UIBezierPath()
        path.move(to: e0)
        path.addCurve(to:e1,
                      controlPoint1: c0,
                      controlPoint2: c1)
        
    }
    */
    
    /*
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let w = 500.0
        let h = 1000.0
        let e0 = CGPoint(x:0, y:h/2)
        let e1 = CGPoint(x:0, y:0)
        
        let c0 = randomPtRect(topLeft: CGPoint(x:-w/2,y:h/2), width: w, height: h/2)
        let c1 = randomPtRect(topLeft: CGPoint(x:-w/2,y:h/2), width: w, height: h/2)
        
        let ex0 = CGPoint(x:0, y:-200)
        let cx0 = randomPtRect(topLeft: CGPoint(x:-w/2,y:0), width: w/2, height:200)
        let cx1 = randomPtRect(topLeft: CGPoint(x:-w/2,y:0), width: w/2, height:200)
        
        let ex1 = CGPoint(x:0, y:-500)
        let cx2 = randomPtRect(topLeft:CGPoint(x:-w/2, y:-200), width: w/2, height: 300)
        let cx3 = randomPtRect(topLeft:CGPoint(x:-w/2, y:-200), width: w/2, height: 300)
        
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

        let cir7 = Ball(position: ex1, radius: 15.0)
        cir7.draw()
        cir7.fillColor = UIColor.purple
        self.addChild(cir7.getNode())

        let cir8 = Ball(position: cx2, radius: 10.0)
        cir8.draw()
        cir8.fillColor = UIColor.white
        self.addChild(cir8.getNode())

        let cir9 = Ball(position: cx3, radius: 10.0)
        cir9.draw()
        cir9.fillColor = UIColor.darkGray
        self.addChild(cir9.getNode())

        
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

        
        path.addCurve(to:ex1,
                      controlPoint1: cx2,
                      controlPoint2: cx3)

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
     */
    
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
        if initTime0 < 0.0{
            initTime0 = currentTime
        }else{
            let diff = currentTime - initTime0
            if diff > 0.0 && self.rotFlag {
                if let missleNode = self.childNode(withName : "rot"){
                    
                    let randDir = CGFloat( Int.random(in:0...1) == 0 ? -1 : 1 )
                    let randAngle = CGFloat.random(in : 4*CGFloat.pi...10*CGFloat.pi)
                    let rot = SKAction.rotate(byAngle: randAngle * randDir, duration: 10.0)
                    
                    let rmIt = SKAction.removeFromParent()
                    self.rotFlag = false

                    let closureX = {
                        print("closureX")
                        self.rotFlag = true
                    }
                    
                    let closure = {
                        print("closure")
                        self.rotFlag = false
                        
                        missleNode.run(SKAction.sequence([rot]), completion:closureX)
                        let ls = randomPtRectList(topLeft:CGPoint(x:-100, y:500), width:400, height:800, count:5)
                        let imgList = ["bullet1.png", "bullet3.png", "bullet4.png"]
                        let ranInx = Int.random(in:0...(imgList.count - 1))
                        for pt in ls {
                            // let vec0 = vec(pt0:pos, pt1:pos + pt)
                            // let node = createShootNodeVec(pos:pos, vector:vec0, imgName : "bullet1.png")
                            if let missleNode = self.childNode(withName : "rot"){
                                let node = self.createShootNodePt(pos:missleNode.position, pt:pt, imgNames : [imgList[ranInx]])
                                let name = "b" + String(self.bulletCount)
                                node.name = name
                                self.bulletSet.insert(node.name!)
                                self.bulletCount += 1
                                self.addChild(node)
                            }
                        }
                    }

                    let e0 = CGPoint(x:0, y:500)
                    let e1 = CGPoint(x:0, y:0)
                    let c0 = CGPoint(x:100, y:100)
                    let c1 = CGPoint(x:10, y:-200)
                    let pathx = UIBezierPath()
                    pathx.move(to: e0)
                    pathx.addCurve(to:e1,
                                   controlPoint1:c0,
                                   controlPoint2:c1)

                    let follow = SKAction.follow(pathx.cgPath,
                                                 asOffset: false,
                                                 orientToPath: false,
                                                 speed: 200.0)
                    // missleNode.run(SKAction.group([follow, rot]), completion:closure)
                    missleNode.run(SKAction.sequence([follow]), completion:closure)
                    
                    
                    // self.addChild(missleNode)
                    
                    // missleNode.run(SKAction.sequence([rot]), completion:closure)
                }
                initTime0 = currentTime
            }
        }

        /*
        if initTime1 < 0.0{
            initTime1 = currentTime
        }else{
            let diff = currentTime - initTime1
            if diff > 1.0 {
                let ls = randomPtRectList(topLeft:CGPoint(x:-100, y:500), width:400, height:800, count:5)
                
                // for pt in [p0, p1, p2, p3, p4, p5]{
                // for ang in [0.0, CGFloat.pi/4, CGFloat.pi/2, CGFloat.pi*3/4, CGFloat.pi]{
                // for pt in [CGPoint(x:1, y:0), CGPoint(x:0, y:1), CGPoint(x:1, y:1)]{
                for pt in ls {
                    // let vec0 = vec(pt0:pos, pt1:pos + pt)
                    // let node = createShootNodeVec(pos:pos, vector:vec0, imgName : "bullet1.png")
                    if let missleNode = self.childNode(withName : "rot"){
                        let node = createShootNodePt(pos:missleNode.position, pt:pt, imgNames : ["bullet1.png"])
                        let name = "b" + String(bulletCount)
                        node.name = name
                        self.bulletSet.insert(node.name!)
                        self.bulletCount += 1
                        self.addChild(node)
                    }
                }
                initTime1 = currentTime
            }
        }
        */
        


    }
}
