import SwiftUI

struct GameView: View {
    @StateObject var gameModel =  GameViewModel()
    @State private var gameSceneID = UUID()
    @State private var isMenu = false
    @Environment(\.presentationMode) var presentationMode
    let isTime: Bool
    
    var scene: SKScene {
        let scene = GameScene()
        scene.size = UIScreen.main.bounds.size
        scene.scaleMode = .resizeFill
        scene.gameViewModel = gameModel
        scene.isTimeGame = isTime
        return scene
    }
    
    var body: some View {
        ZStack {
            SpriteView(scene: scene)
                .ignoresSafeArea()
                .id(gameSceneID)
            
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.white)
                            .font(.system(size: 24, weight: .semibold))
                    }
                    
                    Spacer()
                    
                    Text("The floor is lava")
                        .ProBold(size: 28)
                    
                    Spacer()
                    
                    Button(action: {
                        
                    }) {
                        Rectangle()
                            .fill(Color(red: 255/255, green: 64/255, blue: 58/255))
                            .overlay {
                                HStack(spacing: 5) {
                                    Image(.stars)
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                    
                                    Text("\(UserDefaultsManager().getCoins())")
                                        .ProBold(size: 20)
                                }
                            }
                            .frame(width: 80, height: 40)
                            .cornerRadius(12)
                    }
                }
                .padding(.top, 30)
                
                Spacer()
            }
            
            if gameModel.isGameOver {
                Color.black
                    .opacity(0.7)
                    .ignoresSafeArea()
                    .zIndex(10)
                
                if gameModel.score > gameModel.highestScoreExcludingCurrent {
                    Image( "record")
                        .resizable()
                        .overlay {
                            VStack(spacing: 15) {
                                Text("New record! \(gameModel.score)")
                                    .ProBold(size: 22)
                                
                                HStack {
                                    Button(action: {
                                        gameModel.resetGame()
                                        gameSceneID = UUID()
                                    }) {
                                        Rectangle()
                                            .fill(Color(red: 255/255, green: 64/255, blue: 58/255))
                                            .overlay {
                                                Text("Start again")
                                                    .ProBold(size: 20)
                                            }
                                            .frame(width: 130, height: 40)
                                            .cornerRadius(22)
                                    }
                                    
                                    Button(action: {
                                        isMenu = true
                                    }) {
                                        Rectangle()
                                            .fill(Color(red: 255/255, green: 64/255, blue: 58/255))
                                            .overlay {
                                                Text("Main menu")
                                                    .ProBold(size: 20)
                                            }
                                            .frame(width: 130, height: 40)
                                            .cornerRadius(22)
                                    }
                                }
                            }
                            .offset(y: 50)
                        }
                        .scaledToFit()
                        .frame(width: 350, height: 350)
                        .zIndex(11)
                } else {
                    Image("win")
                        .resizable()
                        .overlay {
                            VStack(spacing: 15) {
                                VStack {
                                    Text("You've scored points: \(gameModel.score)")
                                        .ProBold(size: 22)
                                    
                                    Text("Your record is \(gameModel.allScores.max() ?? 0)")
                                        .Pro(size: 15)
                                }
                                
                                HStack {
                                    Button(action: {
                                        gameModel.resetGame()
                                        gameSceneID = UUID()
                                    }) {
                                        Rectangle()
                                            .fill(Color(red: 255/255, green: 64/255, blue: 58/255))
                                            .overlay {
                                                Text("Start again")
                                                    .ProBold(size: 20)
                                            }
                                            .frame(width: 130, height: 40)
                                            .cornerRadius(22)
                                    }
                                    
                                    Button(action: {
                                        isMenu = true
                                    }) {
                                        Rectangle()
                                            .fill(Color(red: 255/255, green: 64/255, blue: 58/255))
                                            .overlay {
                                                Text("Main menu")
                                                    .ProBold(size: 20)
                                            }
                                            .frame(width: 130, height: 40)
                                            .cornerRadius(22)
                                    }
                                }
                            }
                            .offset(y: 50)
                        }
                        .scaledToFit()
                        .frame(width: 350, height: 350)
                        .zIndex(11)
                }
            }
        }
        .fullScreenCover(isPresented: $isMenu) {
            MainView()
        }
    }
}
#Preview {
    GameView(isTime: true)
}

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    weak var gameViewModel: GameViewModel?
    var isTimeGame: Bool = false
    private var background1: SKSpriteNode!
    private var background2: SKSpriteNode!
    private var player: SKSpriteNode!
    
    private var obstacles = [SKSpriteNode]()
    private var obstacleIndex = 1
    
    private var bg: SKSpriteNode!
    private var topBg: SKSpriteNode!
    private var bottomBg: SKSpriteNode!
    private var timerLabel: SKLabelNode!
    
    private var moveSpeed: CGFloat = 200
    private var lastSpeedIncreaseTime: TimeInterval = 0
    
    private var overlayNode: SKShapeNode?
    private var resultSprite: SKSpriteNode?
    private var score = 0
    private var scoreLabel: SKLabelNode!
    private var timeSinceLastPoint: TimeInterval = 0
    
    private var timer: Timer?
    private var elapsedTime: Int = 0
    
    struct PhysicsCategory {
        static let none: UInt32 = 0
        static let player: UInt32 = 0x1 << 0
        static let platform: UInt32 = 0x1 << 1
        static let lava: UInt32 = 0x1 << 2
    }
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        
        backgroundColor = .clear
        
        setupScoreLabel()
        if isTimeGame {
            setupTimerLabel()
        }
        setupBackground()
        setupPlayer()
        setupPlatforms()
        setupLava()
        
        lastSpeedIncreaseTime = 0
        
        if isTimeGame {
            startTimer()
        }
    }
    
    private func setupTimerLabel() {
        timerLabel = SKLabelNode(fontNamed: "HelveticaNeue-Bold")
        timerLabel.fontSize = 24
        timerLabel.fontColor = .white
        
        timerLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.55)
        timerLabel.zPosition = 100
        
        timerLabel.text = "Time: \(elapsedTime)s"
        addChild(timerLabel)
    }

    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.elapsedTime += 1
            timerLabel.text = "Time: \(elapsedTime)s"
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    override func willMove(from view: SKView) {
        stopTimer()
    }
    
    func resetScene() {
        self.removeAllChildren()
        self.removeAllActions()
        self.physicsWorld.contactDelegate = self
        self.isPaused = false
        
        obstacleIndex = 1
        obstacles.removeAll()
        moveSpeed = 200
        lastSpeedIncreaseTime = 0
        
        timeSinceLastPoint = 0
        
        setupScoreLabel()
        setupBackground()
        setupPlayer()
        setupPlatforms()
        setupLava()
        
        overlayNode?.removeFromParent()
        overlayNode = nil
        resultSprite?.removeFromParent()
        resultSprite = nil
    }
    
    private func setupScoreLabel() {
        scoreLabel = SKLabelNode(fontNamed: "HelveticaNeue-Bold")
        scoreLabel.fontSize = 28
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.65)
        scoreLabel.zPosition = 100
        scoreLabel.text = "+0"
        addChild(scoreLabel)
    }
    
    func setupBackground() {
        let bg2Texture = SKTexture(imageNamed: "bgGame")
        bg = SKSpriteNode(texture: bg2Texture)
        bg.position = CGPoint(x: 0, y: 0)
        addChild(bg)
        
        let bgTopTexture = SKTexture(imageNamed: "blueBg")
        topBg = SKSpriteNode(texture: bgTopTexture)
        topBg.size.height = 150
        topBg.position = CGPoint(x: 0, y: 370)
        topBg.zPosition = 5
        addChild(topBg)
        
        let bgBottomTexture = SKTexture(imageNamed: "puprpleBg")
        bottomBg = SKSpriteNode(texture: bgBottomTexture)
        bottomBg.size.height = 150
        bottomBg.position = CGPoint(x: 0, y: 60)
        bottomBg.zPosition = 5
        addChild(bottomBg)
        
        let bgTexture = SKTexture(imageNamed: "field")
        background1 = SKSpriteNode(texture: bgTexture)
        background1.anchorPoint = CGPoint.zero
        background1.size.height = 350
        background1.position = CGPoint(x: 0, y: 0)
        background1.zPosition = 3
        addChild(background1)
        
        background2 = SKSpriteNode(texture: bgTexture)
        background2.anchorPoint = CGPoint.zero
        background2.size.height = 350
        background2.position = CGPoint(x: background1.size.width, y: 0)
        background2.zPosition = 3
        addChild(background2)
    }
    
    func setupPlayer() {
        let playerTexture = SKTexture(imageNamed: "runner")
        player = SKSpriteNode(texture: playerTexture)
        player.size = CGSize(width: 60, height: 100)
        player.position = CGPoint(x: size.width * 0.25, y: size.height * 0.25)
        player.zPosition = 5
        
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.categoryBitMask = PhysicsCategory.player
        player.physicsBody?.contactTestBitMask = PhysicsCategory.platform | PhysicsCategory.lava
        player.physicsBody?.collisionBitMask = PhysicsCategory.platform
        player.physicsBody?.affectedByGravity = true
        player.physicsBody?.allowsRotation = false
        addChild(player)
    }
    
    func setupPlatforms() {
        for i in 0..<4 {
            addPlatform(at: CGPoint(x: CGFloat(130 + i * 250), y: size.height * 0.12))
        }
    }
    
    func addPlatform(at position: CGPoint) {
        let obstacleName = "obstacle\(obstacleIndex)"
        obstacleIndex += 1
        if obstacleIndex > 9 { obstacleIndex = 1 }
        
        let texture = SKTexture(imageNamed: obstacleName)
        let platform = SKSpriteNode(texture: texture)
        platform.position = position
        platform.zPosition = 4
        platform.size = CGSize(width: 230, height: 100)
        
        platform.physicsBody = SKPhysicsBody(texture: texture, size: platform.size)
        platform.physicsBody?.isDynamic = false
        platform.physicsBody?.categoryBitMask = PhysicsCategory.platform
        platform.physicsBody?.contactTestBitMask = PhysicsCategory.player
        platform.physicsBody?.collisionBitMask = PhysicsCategory.player
        
        addChild(platform)
        obstacles.append(platform)
    }
    
    func setupLava() {
        let lavaHeight: CGFloat = 50
        let lava = SKNode()
        lava.position = CGPoint(x: size.width / 2, y: lavaHeight / 2)
        lava.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width, height: lavaHeight))
        lava.physicsBody?.isDynamic = false
        lava.physicsBody?.categoryBitMask = PhysicsCategory.lava
        lava.physicsBody?.contactTestBitMask = PhysicsCategory.player
        lava.physicsBody?.collisionBitMask = PhysicsCategory.none
        addChild(lava)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let onGroundTolerance: CGFloat = 25.0
        
        if let body = player.physicsBody, abs(body.velocity.dy) < onGroundTolerance {
            let jumpImpulseUp: CGFloat = 210
            let jumpImpulseForward: CGFloat = 30
            body.applyImpulse(CGVector(dx: jumpImpulseForward, dy: jumpImpulseUp))
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard lastSpeedIncreaseTime > 0 else {
            lastSpeedIncreaseTime = currentTime
            return
        }
        
        if lastUpdateTime == 0 {
            lastUpdateTime = currentTime
            return
        }
        dt = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        
        timeSinceLastPoint += dt
        if timeSinceLastPoint >= 2.0 {
            score += 1
            scoreLabel.text = "+\(score)"
            timeSinceLastPoint = 0
        }
        
        let deltaTime = currentTime - lastSpeedIncreaseTime
        
        if deltaTime >= 15 {
            moveSpeed += 50
            lastSpeedIncreaseTime = currentTime
        }
        
        let distance = moveSpeed * CGFloat(self.dt)
        background1.position.x -= distance
        background2.position.x -= distance
        
        if background1.position.x <= -background1.size.width {
            background1.position.x = background2.position.x + background2.size.width
        }
        if background2.position.x <= -background2.size.width {
            background2.position.x = background1.position.x + background1.size.width
        }
        
        for platform in obstacles {
            platform.position.x -= distance
            if platform.position.x < -platform.size.width / 2 {
                platform.position.x = size.width + platform.size.width / 2
            }
        }
        
        if player.position.x < 0 || player.position.x > size.width {
            gameOver()
        }
    }
    
    private var lastUpdateTime: TimeInterval = 0
    private var dt: TimeInterval = 0
    
    override func didEvaluateActions() {
        if lastUpdateTime == 0 {
            lastUpdateTime = CACurrentMediaTime()
        }
        let currentTime = CACurrentMediaTime()
        dt = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if contactMask == PhysicsCategory.player | PhysicsCategory.lava {
            gameOver()
        }
    }
    
    func gameOver() {
        isPaused = true
        
        DispatchQueue.main.async {
            self.gameViewModel?.isGameOver = true
            self.gameViewModel?.score = self.score
            if let viewModel = self.gameViewModel {
                viewModel.addScore(self.score)
                UserDefaultsManager().addCoins(1)
            }
        }
    }
}
