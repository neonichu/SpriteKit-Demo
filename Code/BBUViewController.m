//
//  BBUViewController.m
//  PuckMan
//
//  Created by Boris Bügling on 01.02.14.
//  Copyright (c) 2014 Boris Bügling. All rights reserved.
//

#import "BBUMyScene.h"
#import "BBUViewController.h"

@implementation BBUViewController

- (void)loadView
{
    self.view = [[SKView alloc] initWithFrame:[UIScreen mainScreen].bounds];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    SKView * skView = (SKView *)self.view;
    //skView.showsFPS = YES;
    //skView.showsNodeCount = YES;
    
    SKScene * scene = [BBUMyScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [skView presentScene:scene];
}

@end
