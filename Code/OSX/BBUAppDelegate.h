//
//  BBUAppDelegate.h
//  PuckMan-OSX
//

//  Copyright (c) 2014 Boris Bügling. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <SpriteKit/SpriteKit.h>

@interface BBUAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet SKView *skView;

@end
