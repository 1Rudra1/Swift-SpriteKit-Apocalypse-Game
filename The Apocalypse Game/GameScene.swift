//
//  GameScene.swift
//  The Apocalypse Game
//
//  Created by Rudra Patel on 1/22/22.
//

import SpriteKit
import GameplayKit



struct PhyscisCategory{
    static let None : UInt32 = 0b01
    static let All : UInt32 = UInt32.max
    static let Ball : UInt32 = 0b001
    static let Hero : UInt32 = 0b010
    static let Coin : UInt32 = 0b100
}


//SettingsData.shared.speed


class GameScene: SKScene, SKPhysicsContactDelegate {
     
    var background = SKSpriteNode(imageNamed: "background")
    var sportNode : SKSpriteNode?
    var score : Int?
    var lives : Int?
    let scoreIncrement = 10
    var lblScore = SKLabelNode()
    var lblTitle = SKLabelNode()
    var lblLives = SKLabelNode()
    var lblGameOver = SKLabelNode()
    var lblTimer = SKLabelNode()
    var lblTimeUp = SKLabelNode()
    var invisNum = 1
    var counter = 60
    var counterTimer = Timer()
    var counterStartValue = 60
    var coinsCollected = 0

 
    
    
    func initLabels(){
        lblScore.name = "lblScore"
        lblScore.text = "Score:"
        lblScore.fontSize = 44
        lblScore.fontColor = .yellow
        lblScore.position = CGPoint(x: 380, y: 1040)
        lblScore.zPosition = 11
        addChild(lblScore)
        
        
        lblLives.name = "lblLives"
        lblLives.text = "Lives: 3"
        lblLives.fontSize = 44
        lblLives.fontColor = .yellow
        lblLives.position = CGPoint(x: 1620, y: 1040)
        lblLives.zPosition = 11
        addChild(lblLives)
        
        
        lblTitle.name = "lblTitle"
        lblTitle.text = "Cannon Coin"
        lblTitle.fontSize = 55
        lblTitle.fontColor = .red
        lblTitle.fontName = "AvenirNext-Bold"
        lblTitle.position = CGPoint(x: 1000, y: 1080)
        lblTitle.zPosition = 11
        addChild(lblTitle)
        
        
        lblTimer.name = "lblTimer"
        lblTimer.text = "Timer: "
        lblTimer.fontSize = 48
        lblTimer.fontColor = .green
        lblTimer.fontName = "AvenirNext"
        lblTimer.position = CGPoint(x: 1000, y: 1020)
        lblTimer.zPosition = 11
        addChild(lblTimer)
    }
    
    
    func startTimer(){
        counterTimer = Timer.scheduledTimer(timeInterval: TimeInterval(1.0), target: self, selector: #selector(decrementCounter), userInfo: nil, repeats: true)
    }
    

    
    @objc func decrementCounter(){
        counter -= 1
        lblTimer.text = "Timer: \(counter)"
        
        if(counter<=0){
            sportNode?.removeFromParent()
         
            lblTimeUp.name = "lblTimeUp"
            lblTimeUp.text = "GAME OVER"
            lblTimeUp.fontSize = 94
            lblTimeUp.fontColor = .white
            lblTimeUp.fontName = "AvenirNext-Bold"
            lblTimeUp.position = CGPoint(x: 1000, y: 750)
            lblTimeUp.zPosition = 11
            addChild(lblTimeUp)
            counter = 1
            
            CFRunLoopTimerInvalidate(counterTimer)
        }
        
    }
    
    
    override func didMove(to view: SKView) {
        
        initLabels()
        addAllCoins()
        background.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        background.alpha = 0.3
        addChild(background)
        
        lblTitle.alpha = 0.0
        lblTitle.run(SKAction.fadeIn(withDuration: 2.0))
    
        lblTimer.alpha = 0.0
        lblTimer.run(SKAction.fadeIn(withDuration: 2.0))
        
       
        sportNode = SKSpriteNode(imageNamed: "player")
        sportNode?.position = CGPoint(x: 1000, y: 720)
        sportNode?.setScale(0.09)
        
        addChild(sportNode!)
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        sportNode?.physicsBody = SKPhysicsBody(circleOfRadius: 50)
        sportNode?.physicsBody?.isDynamic = true
        sportNode?.physicsBody?.categoryBitMask = PhyscisCategory.Hero
        sportNode?.physicsBody?.contactTestBitMask = PhyscisCategory.Ball | PhyscisCategory.Coin
        sportNode?.physicsBody?.collisionBitMask = PhyscisCategory.None
        sportNode?.physicsBody?.usesPreciseCollisionDetection = true
        
        
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(addAllCannons),SKAction.wait(forDuration: SettingsData.shared.speed)])))
    
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(addAllCannons2),SKAction.wait(forDuration: SettingsData.shared.speed + 2.00)])))
        
        score = 0
        lblScore.text = "Score: \(score!)"
        lblScore.alpha = 0.0
        lblScore.run(SKAction.fadeIn(withDuration: 2.0))
        
        lives = 3
        lblLives.text = "Lives: \(lives!)"
        lblLives.alpha = 0.0
        lblLives.run(SKAction.fadeIn(withDuration: 2.0))
        
        
        counter = counterStartValue
        startTimer()
    }
  
    
    func random() -> CGFloat{
        return CGFloat(Float(arc4random())/0xFFFFFFFF)
    }
    
    
    func random(min: CGFloat, max:CGFloat)->CGFloat{
        return random() * (max-min)+min
    }
    


    func addCannons(cPositionX:CGFloat, cPositionY: CGFloat, invisible: Bool){
        let cannon = SKSpriteNode(imageNamed: "cannon")
        cannon.setScale(0.06)
        cannon.xScale = cannon.xScale * -1
        cannon.position = CGPoint(x:(cPositionX), y:(cPositionY))
        addChild(cannon)
        
        if(invisible == false){
            let ball = SKSpriteNode(imageNamed: "cannonBall")

            ball.setScale(0.05)
            
          
            ball.xScale = ball.xScale * -1

            ball.position = CGPoint(x:(cPositionX-50.0), y: (cPositionY+10.00))
        
            addChild(ball)

            ball.physicsBody = SKPhysicsBody(rectangleOf: ball.size)
            ball.physicsBody?.isDynamic = false
            ball.physicsBody?.categoryBitMask = PhyscisCategory.Ball
            ball.physicsBody?.contactTestBitMask = PhyscisCategory.Hero
            ball.physicsBody?.collisionBitMask = PhyscisCategory.None

            let actualDuration = random(min: CGFloat(3.0), max: CGFloat(5.0))

            let actionMove = SKAction.move(to: CGPoint(x:-100.0, y: cPositionY), duration: actualDuration)

            let actionMoveDone = SKAction.removeFromParent()


            ball.run(SKAction.sequence([actionMove,actionMoveDone]))
        }
        else{
            let actionSpin = SKAction.rotate(byAngle: CGFloat(360), duration: TimeInterval(2.0))
            let actionRemove = SKAction.removeFromParent()
            cannon.run(SKAction.sequence([actionSpin, actionRemove]))
        }
    }
    
    
    func addSpecialCannons(cPositionX:CGFloat, cPositionY: CGFloat, invisible: Bool){
        
        let cannon = SKSpriteNode(imageNamed: "cannon")
        cannon.setScale(0.06)
        cannon.position = CGPoint(x:(cPositionX), y:(cPositionY))
        addChild(cannon)
        
        if(invisible == false){
            let ball = SKSpriteNode(imageNamed: "cannonBall")
            
            
            ball.setScale(0.05)
        

            ball.position = CGPoint(x:(cPositionX+60.0), y: (cPositionY+15.00))
         
            
            addChild(ball)
            
            ball.physicsBody = SKPhysicsBody(rectangleOf: ball.size)
            ball.physicsBody?.isDynamic = false
            ball.physicsBody?.categoryBitMask = PhyscisCategory.Ball
            ball.physicsBody?.contactTestBitMask = PhyscisCategory.Hero
            ball.physicsBody?.collisionBitMask = PhyscisCategory.None
            
            
            let actualDuration = random(min: CGFloat(3.0), max: CGFloat(5.0))

            let actionMove = SKAction.move(to: CGPoint(x:1900, y: cPositionY), duration: actualDuration)
            
            let actionMoveDone = SKAction.removeFromParent()
            
            
            ball.run(SKAction.sequence([actionMove,actionMoveDone]))
        }
        else{
            let actionSpin = SKAction.rotate(byAngle: CGFloat(360), duration: TimeInterval(2.0))
            let actionRemove = SKAction.removeFromParent()
            cannon.run(SKAction.sequence([actionSpin, actionRemove]))
        }
    }
    
    
    func addAllCannons(){
        
        if(invisNum==1){
            addCannons(cPositionX: 900, cPositionY: 700, invisible: true)
            addCannons(cPositionX: 1750, cPositionY: 400, invisible: false)
            addSpecialCannons(cPositionX: 200, cPositionY: 850, invisible: false)
            invisNum = invisNum + 1
        }
        else if (invisNum == 3){
            addCannons(cPositionX: 900, cPositionY: 700, invisible: false)
            addCannons(cPositionX: 1750, cPositionY: 400, invisible: true)
            addSpecialCannons(cPositionX: 200, cPositionY: 850, invisible: false)
            invisNum = invisNum + 1
        }
        else if(invisNum == 5){
            addCannons(cPositionX: 900, cPositionY: 700, invisible: false)
            addCannons(cPositionX: 1750, cPositionY: 400, invisible: false)
            addSpecialCannons(cPositionX: 200, cPositionY: 850, invisible: true)
            invisNum = invisNum + 1
        }
        else{
            addCannons(cPositionX: 900, cPositionY: 700, invisible: false)
            addCannons(cPositionX: 1750, cPositionY: 400, invisible: false)
            addSpecialCannons(cPositionX: 200, cPositionY: 850, invisible: false)
        }
    }
    
    
    func addAllCannons2(){
        
        if(invisNum==2){
            addCannons(cPositionX: 1750, cPositionY: 950, invisible: true)
            addSpecialCannons(cPositionX: 1100, cPositionY: 700, invisible: false)
            addSpecialCannons(cPositionX: 200, cPositionY: 550, invisible: false)
            invisNum = invisNum + 1
        }
        else if (invisNum == 4){
            addCannons(cPositionX: 1750, cPositionY: 950, invisible: false)
            addSpecialCannons(cPositionX: 1100, cPositionY: 700, invisible: true)
            addSpecialCannons(cPositionX: 200, cPositionY: 550, invisible: false)
            invisNum = invisNum + 1
        }
        else if(invisNum == 6){
            addCannons(cPositionX: 1750, cPositionY: 950, invisible: false)
            addSpecialCannons(cPositionX: 1100, cPositionY: 700, invisible: false)
            addSpecialCannons(cPositionX: 200, cPositionY: 550, invisible: true)
            invisNum = 1
        }
        else{
            addCannons(cPositionX: 1750, cPositionY: 950, invisible: false)
            addSpecialCannons(cPositionX: 1100, cPositionY: 700, invisible: false)
            addSpecialCannons(cPositionX: 200, cPositionY: 550, invisible: false)
        }

        
    }
    
    
    
    func addAllCoins(){
        for i in 1...30 {
            addCoin()
        }
    }
    
    func addCoin(){
        let coin = SKSpriteNode(imageNamed: "coin")

        let actualX = random(min: 200, max: 1600)
        let actualY = random(min: 400, max: 1000)
   
        coin.setScale(0.025)

        coin.position = CGPoint(x:actualX, y:actualY)
        
        addChild(coin)
 
        coin.physicsBody = SKPhysicsBody(rectangleOf: coin.size)
        coin.physicsBody?.isDynamic = false
        coin.physicsBody?.categoryBitMask = PhyscisCategory.Coin
        coin.physicsBody?.contactTestBitMask = PhyscisCategory.Hero
        coin.physicsBody?.collisionBitMask = PhyscisCategory.None
    }
    
    
    
    func moveGoodGuy(pos: CGPoint){
        let actionMove = SKAction.move(to: pos, duration: TimeInterval(1.0))
        
        sportNode?.run(SKAction.sequence([actionMove]))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let pos : CGPoint = (touches.first?.location(in:self))!
        
        moveGoodGuy(pos: pos)
    }
    
    
    func heroDidCollideWithBaddy(ball : SKSpriteNode, hero : SKSpriteNode){
        
        ball.removeFromParent()
        
        lblScore.alpha = 0.0
        lblScore.run(SKAction.fadeIn(withDuration: 1.0))
        
        lives = lives! - 1
        lblLives.text = "Lives:\(lives!)"
        
        lblLives.alpha = 0.0
        lblLives.run(SKAction.fadeIn(withDuration: 1.0))
        
        if(lives!<=0){
            lblGameOver.name = "lblGameOver"
            lblGameOver.text = "GAME OVER"
            lblGameOver.fontSize = 94
            lblGameOver.fontColor = .white
            lblGameOver.fontName = "AvenirNext-Bold"
            lblGameOver.position = CGPoint(x: 1000, y: 700)
            lblGameOver.zPosition = 11
            addChild(lblGameOver)
            hero.removeFromParent()
            
        }
        else{
            let homePoint = CGPoint(x: 1000, y: 720)
            let actionMove = SKAction.move(to: homePoint, duration: TimeInterval(0.0))
            sportNode?.run(SKAction.sequence([actionMove]))
        }
        
    }
    
    
    func heroDidCollideWithCoin(hero : SKSpriteNode, coin : SKSpriteNode){
        coin.removeFromParent()
        score = score!+counter
        lblScore.text = "Score: \(score!)"
        lblScore.alpha = 0.0
        lblScore.run(SKAction.fadeIn(withDuration: 2.0))
        coinsCollected+=1
        
        if(coinsCollected == 30){
            hero.removeFromParent()
            lblGameOver.name = "lblGameOver"
            lblGameOver.text = "You won with \(counter) seconds left and \(score ?? 0) points!"
            lblGameOver.fontSize = 54
            lblGameOver.fontColor = .white
            lblGameOver.fontName = "AvenirNext-Bold"
            lblGameOver.position = CGPoint(x: 1000, y: 700)
            lblGameOver.zPosition = 11
            addChild(lblGameOver)
        }
        
        
    }
    
    
    
    func didBegin(_ contact: SKPhysicsContact){
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody

        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }
        else{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }


        if((firstBody.categoryBitMask & PhyscisCategory.Ball != 0) && (secondBody.categoryBitMask & PhyscisCategory.Hero != 0)){
            heroDidCollideWithBaddy(ball: firstBody.node as! SKSpriteNode, hero: secondBody.node as! SKSpriteNode)
        }
        else if((firstBody.categoryBitMask & PhyscisCategory.Hero != 0) && (secondBody.categoryBitMask & PhyscisCategory.Coin != 0)){
            heroDidCollideWithCoin(hero: firstBody.node as! SKSpriteNode, coin: secondBody.node as! SKSpriteNode)

        }
        
    }

    
}
