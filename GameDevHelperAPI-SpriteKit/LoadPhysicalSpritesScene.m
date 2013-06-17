//
//  LoadPhysicalSpritesScene.m
//  GameDevHelperAPI-SpriteKit
//
//  Created by Bogdan Vladu on 6/14/13.
//  Copyright (c) 2013 Bogdan Vladu. All rights reserved.
//

#import "LoadPhysicalSpritesScene.h"

@implementation LoadPhysicalSpritesScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        
        [self buildWorld];
        
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        myLabel.text = @"Load physical sprites using Sprite Kit";
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
    
    NSArray *spriteImageNames = [NSArray arrayWithObjects:
                                 @"backpack",
                                 @"banana",
                                 @"bananabunch",
                                 @"canteen",
                                 @"hat",
                                 @"pineapple",
                                 @"statue",
                                 @"ball",
                                 nil];
    
    
    int spriteNameIdx = arc4random() % [spriteImageNames count];
    
    NSString* spriteImageName = [spriteImageNames objectAtIndex:spriteNameIdx];
    
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        GHSprite* sprite = [GHSprite spriteNodeWithImageNamed:spriteImageName
                                              physicsFileName:@"PhysicalSpritesObjects_Objects"
                                                    directory:@"bodies"];
        
        sprite.position = location;
        
        [self addChild:sprite];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
