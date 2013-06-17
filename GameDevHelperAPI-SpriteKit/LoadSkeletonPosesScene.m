//
//  LoadSkeletonPosesScene.m
//  GameDevHelperAPI-SpriteKit
//
//  Created by Bogdan Vladu on 6/14/13.
//  Copyright (c) 2013 Bogdan Vladu. All rights reserved.
//

#import "LoadSkeletonPosesScene.h"

@implementation LoadSkeletonPosesScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        
        [self buildWorld];
        
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        myLabel.text = @"Load skeleton poses using Sprite Kit";
        myLabel.fontSize = 12;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
        
        SKLabelNode *myLabel2 = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        myLabel2.text = @"from SpriteHelper 2 generated files.";
        myLabel2.fontSize = 12;
        myLabel2.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame)-12);
        
        
        [self addChild:myLabel];
        [self addChild:myLabel2];
    }
    return self;
}

- (void)buildWorld {

    // Configure physics for the world.
    self.physicsWorld.gravity = CGPointMake(0, -2); // no gravity
    
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];

        if(skeleton == nil){
            skeleton = [GHSkeleton skeletonWithFile:@"Officer_Officer"
                                                  directory:@"skeletons"];
        
            skeleton.position = location;
        
            [self addChild:skeleton];            
        }
        else{
            [self changePose];
        }
    }
}

-(void)changePose{
    
    NSArray *poseNames = [NSArray arrayWithObjects:
                          @"DefaultPose",
                          @"BowPose",
                          @"DeathPose",
                          @"HatWave",
                          @"IdlePose",
                          @"PushPose",
                          @"ShootPose",
                          nil];
    
    NSString* finalPoseName = [poseNames objectAtIndex:currentPose];
    ++currentPose;
    
    if(currentPose >= [poseNames count])
        currentPose = 0;
    
    [skeleton setPoseWithName:finalPoseName];
}


-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
