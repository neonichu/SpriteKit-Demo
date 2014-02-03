//
//  BBUGameOverScene.h
//  PuckMan
//
//  Created by Boris Bügling on 04.02.14.
//  Copyright (c) 2014 Boris Bügling. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef void(^BBUGameOverDismissedHandler)();

@interface BBUGameOverScene : SKScene

@property (copy) BBUGameOverDismissedHandler dismissHandler;
@property (nonatomic) NSInteger score;

@end
