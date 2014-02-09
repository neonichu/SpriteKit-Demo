//
//  BBUGameOverScene.m
//  PuckMan
//
//  Created by Boris Bügling on 04.02.14.
//  Copyright (c) 2014 Boris Bügling. All rights reserved.
//

#import "BBUGameOverScene.h"

@interface BBUGameOverScene ()

@property SKLabelNode* scoreLabel;

@end

#pragma mark -

@implementation BBUGameOverScene

-(instancetype)initWithSize:(CGSize)size {
    self = [super initWithSize:size];
    if (self) {
        self.backgroundColor = [SKColor blackColor];
        
        SKLabelNode* gameOverLabel = [SKLabelNode node];
        gameOverLabel.fontSize = 40.0;
        gameOverLabel.fontName = @"Chalkduster";
        gameOverLabel.position = CGPointMake(self.size.width / 2, self.size.height / 2);
        gameOverLabel.text = @"Schade.";
        [self addChild:gameOverLabel];
        
        self.scoreLabel = [SKLabelNode node];
        self.scoreLabel.fontSize = 30.0;
        self.scoreLabel.fontName = @"Chalkduster";
        self.scoreLabel.position = CGPointMake(self.size.width / 2, gameOverLabel.position.y - 100.0);
        [self addChild:self.scoreLabel];
    }
    return self;
}

-(void)setScore:(NSInteger)score {
    _score = score;
    
    self.scoreLabel.text = [NSString stringWithFormat:@"%ld Punkte", (long)score];
}

#if TARGET_OS_IPHONE

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.dismissHandler) {
        self.dismissHandler();
    }
}

#endif

@end
