//
//  BBUMyScene.m
//  PuckMan
//
//  Created by Boris Bügling on 01.02.14.
//  Copyright (c) 2014 Boris Bügling. All rights reserved.
//

#import <GameController/GameController.h>

#import "BBUGameOverScene.h"
#import "BBUMyScene.h"

static NSString* const kEnemyMoveAction     = @"EnemyMoveAction";
static NSString* const kPuckManMoveAction   = @"PuckManMoveAction";

static const uint32_t worldCategory         =  0x1 << 0;
static const uint32_t playerCategory        =  0x1 << 1;
static const uint32_t enemyCategory         =  0x1 << 2;
static const uint32_t dotCategory           =  0x1 << 3;

typedef enum {
    Left,
    Right,
    Up,
    Down,
} BBUDirection;

CGFloat DegreesToRadians(CGFloat degrees) {
    return degrees * M_PI / 180;
};

#pragma mark -

@interface BBUMyScene () <SKPhysicsContactDelegate>

@property SKSpriteNode* puckMan;
@property NSUInteger score;
@property SKLabelNode* scoreLabel;

@end

#pragma mark -

@implementation BBUMyScene

-(void)createDots {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddArc(path, &CGAffineTransformIdentity, 3.0, 3.0, 3.0, 0.0, 2 * M_PI, YES);
    
    for (int i = 1; i < self.size.width / 25 - 1; i++) {
        for (int j = 1; j < self.size.height / 35; j++) {
            SKShapeNode* dot = [SKShapeNode node];
            dot.fillColor = [SKColor redColor];
            dot.path = path;
            dot.position = CGPointMake(26.0 * i, 35.0 * j - 6.0);
            dot.strokeColor = dot.fillColor;
            [self addChild:dot];
            
            dot.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:3.0];
            dot.physicsBody.categoryBitMask = dotCategory;
            dot.physicsBody.collisionBitMask = worldCategory;
        }
    }
    
    CGPathRelease(path);
}

-(void)createEnemyAtPosition:(CGPoint)position {
    SKSpriteNode* enemy = [SKSpriteNode spriteNodeWithImageNamed:@"Ghost"];
    enemy.position = position;
    enemy.size = CGSizeMake(50.0, 50.0);
    [self addChild:enemy];
    
    enemy.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:enemy.size];
    enemy.physicsBody.categoryBitMask = enemyCategory;
    enemy.physicsBody.collisionBitMask = worldCategory | playerCategory;
    
    CGFloat byX = (arc4random_uniform(3) - 1) * 10.0;
    CGFloat byY = (arc4random_uniform(3) - 1) * 10.0;
    SKAction* moveAction = [SKAction moveByX:byX y:byY duration:0.2];
    [enemy runAction:[SKAction repeatActionForever:moveAction] withKey:kEnemyMoveAction];
}

-(void)createLabyrinth {
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, &CGAffineTransformIdentity, 0.0, 0.0);
    CGPathAddLineToPoint(path, &CGAffineTransformIdentity, 0.0, self.size.height / 2 - 25.0);
    CGPathMoveToPoint(path, &CGAffineTransformIdentity, 0.0, self.size.height / 2 + 25.0);
    CGPathAddLineToPoint(path, &CGAffineTransformIdentity, 0.0, self.size.height);
    CGPathAddLineToPoint(path, &CGAffineTransformIdentity, self.size.width, self.size.height);
    CGPathAddLineToPoint(path, &CGAffineTransformIdentity, self.size.width, self.size.height / 2 + 25.0);
    CGPathMoveToPoint(path, &CGAffineTransformIdentity, self.size.width, self.size.height / 2 - 25.0);
    CGPathAddLineToPoint(path, &CGAffineTransformIdentity, self.size.width, 0.0);
    CGPathAddLineToPoint(path, &CGAffineTransformIdentity, 0.0, 0.0);
    
    SKShapeNode* shapeNode = [SKShapeNode node];
    shapeNode.lineWidth = 10.0;
    shapeNode.path = path;
    shapeNode.strokeColor = [SKColor blueColor];
    [self addChild:shapeNode];
    
    CGPathRelease(path);
}

-(void)createPlayer {
    SKTexture* full = [SKTexture textureWithImageNamed:@"PuckManFull"];
    SKTexture* mouth = [SKTexture textureWithImageNamed:@"PuckManMouth"];
    
    self.puckMan = [SKSpriteNode spriteNodeWithTexture:full];
    self.puckMan.position = CGPointMake(self.size.width / 2, self.size.height / 2);
    self.puckMan.size = CGSizeMake(50.0, 50.0);
    [self addChild:self.puckMan];
    
    self.puckMan.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.puckMan.size];
    self.puckMan.physicsBody.categoryBitMask = playerCategory;
    self.puckMan.physicsBody.collisionBitMask = worldCategory;
    self.puckMan.physicsBody.contactTestBitMask = dotCategory | enemyCategory;
    
    SKAction* animate = [SKAction animateWithTextures:@[ full, mouth ] timePerFrame:0.1];
    [self.puckMan runAction:[SKAction repeatActionForever:animate]];
    
    //SKAction* wakaWaka = [SKAction playSoundFileNamed:@"waka-waka.mp3" waitForCompletion:YES];
    //[self.puckMan runAction:[SKAction repeatActionForever:wakaWaka]];
}

-(void)createScoreLabel {
    self.scoreLabel = [SKLabelNode node];
    self.scoreLabel.fontSize = 15.0;
    self.scoreLabel.position = CGPointMake(60.0, 10.0);
    [self addChild:self.scoreLabel];
    
    [self updateScore];
}

-(void)movePlayerInDirection:(BBUDirection)direction {
    CGFloat byX = 0.0, byY = 0.0;
    
    switch (direction) {
        case Left:
            byX -= 10.0;
            self.puckMan.zRotation = DegreesToRadians(180.0);
            break;
        case Right:
            byX += 10.0;
            self.puckMan.zRotation = 0.0;
            break;
        case Up:
            byY -= 10.0;
            self.puckMan.zRotation = DegreesToRadians(-90.0);
            break;
        case Down:
            byY += 10.0;
            self.puckMan.zRotation = DegreesToRadians(90.0);
            break;
    }
    
    SKAction* moveAction = [SKAction moveByX:byX y:byY duration:0.2];
    [self.puckMan runAction:[SKAction repeatActionForever:moveAction] withKey:kPuckManMoveAction];
}

-(void)updateScore {
    self.scoreLabel.text = [NSString stringWithFormat:@"Punkte: %lu", (unsigned long)self.score];
}

#pragma mark -

-(void)createNodes {
    [self createLabyrinth];
    [self createDots];
    [self createEnemyAtPosition:CGPointMake(25.0, 25.0)];
    [self createPlayer];
    [self createScoreLabel];
}

-(instancetype)initWithSize:(CGSize)size {
    self = [super initWithSize:size];
    if (self) {
        self.backgroundColor = [SKColor blackColor];
        
        self.physicsWorld.contactDelegate = self;
        self.physicsWorld.gravity = CGVectorMake(0.0, 0.0);
        
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectInset(self.frame, 11.0, 11.0)];
        self.physicsBody.categoryBitMask = worldCategory;
        
        [self reset];
        [self createNodes];
    }
    return self;
}

-(void)reset {
    self.score = 0;
    [self removeAllChildren];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

#pragma mark - SKPhysicsContactDelegate


-(void)didBeginContact:(SKPhysicsContact *)contact {
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    } else {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if (((firstBody.categoryBitMask & playerCategory) != 0) && ((secondBody.categoryBitMask & dotCategory) != 0)) {
        [secondBody.node removeFromParent];
        
        self.score += 50;
        [self updateScore];
    }
    
    if (((firstBody.categoryBitMask & playerCategory) != 0) && ((secondBody.categoryBitMask & enemyCategory) != 0)) {
        [self reset];
        
        BBUGameOverScene* scene = [BBUGameOverScene sceneWithSize:self.size];
        scene.score = self.score;
        [self addChild:scene];
        
        __weak typeof(self) sself = self;
        scene.dismissHandler = ^() {
            [sself reset];
            [sself createNodes];
        };
    }
}

#pragma mark - Game Controller handling

-(void)handleElement:(GCControllerElement*)element asButton:(GCControllerButtonInput*)button correspondingToDirection:(BBUDirection)direction {
    if (button == element) {
        if (button.isPressed) {
            [self movePlayerInDirection:direction];
        } else {
            [self.puckMan removeActionForKey:kPuckManMoveAction];
        }
    }
}

-(void)startHandlingGameControllers {
    for (GCController* controller in [GCController controllers]) {
        GCGamepad* gamepad = controller.gamepad;
        
        gamepad.valueChangedHandler = ^(GCGamepad* gamepad, GCControllerElement* element) {
            [self handleElement:element asButton:gamepad.dpad.up correspondingToDirection:Up];
            [self handleElement:element asButton:gamepad.dpad.down correspondingToDirection:Down];
            [self handleElement:element asButton:gamepad.dpad.left correspondingToDirection:Left];
            [self handleElement:element asButton:gamepad.dpad.right correspondingToDirection:Right];
        };
    }
}

#pragma mark - Touch handling

#if TARGET_OS_IPHONE

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (touches.count != 1) {
        return;
    }
    
    CGPoint location = [[touches anyObject] locationInNode:self];
    
    if (location.x > self.size.width - 100 && location.x < self.size.width) {
        [self movePlayerInDirection:Right];
    }
    
    if (location.x > 0.0 && location.x < 100.0) {
        [self movePlayerInDirection:Left];
    }
    
    if (location.y > self.size.height - 100.0 && location.y < self.size.height) {
        [self movePlayerInDirection:Down];
    }
    
    if (location.y > 0.0 && location.y < 100.0) {
        [self movePlayerInDirection:Up];
    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.puckMan removeActionForKey:kPuckManMoveAction];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.puckMan removeActionForKey:kPuckManMoveAction];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.puckMan removeActionForKey:kPuckManMoveAction];
}

#endif

@end
