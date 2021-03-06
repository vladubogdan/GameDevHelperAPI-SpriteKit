//
//  LoadSimpleSpritesScene.m
//  GameDevHelperAPI-SpriteKit
//
//  Created by Bogdan Vladu on 6/14/13.
//  Copyright (c) 2013 Bogdan Vladu. All rights reserved.
//

#import "LoadSimpleSpritesScene.h"

@implementation LoadSimpleSpritesScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        myLabel.text = @"Load sprites using Sprite Kit";
        myLabel.fontSize = 12;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
        
        SKLabelNode *myLabel2 = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        myLabel2.text = @"from SpriteHelper 2 generated Atlas file.";
        myLabel2.fontSize = 12;
        myLabel2.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame)-12);
        
        
        [self addChild:myLabel];
        [self addChild:myLabel2];
    }
    return self;
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
                                 nil];
    
    
    int spriteNameIdx = arc4random() % [spriteImageNames count];
    
    NSString* spriteImageName = [spriteImageNames objectAtIndex:spriteNameIdx];
    
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:spriteImageName];
        
        sprite.position = location;
        
        [self addChild:sprite];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
