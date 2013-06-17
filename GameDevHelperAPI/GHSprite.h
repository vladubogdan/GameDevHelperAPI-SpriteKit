//
//  GHSprite.h
//  GameDevHelperAPI-SpriteKit
//
//  Created by Bogdan Vladu on 6/17/13.
//  Copyright (c) 2013 Bogdan Vladu. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GHSprite : SKSpriteNode
{
    NSDictionary* physicsInfo;
}

+ (instancetype)spriteNodeWithImageNamed:(NSString *)name;

+ (instancetype)spriteNodeWithImageNamed:(NSString *)name
                         physicsFileName:(NSString*)filePath
                               directory:(NSString*)dir;

- (instancetype)initWithImageNamed:(NSString *)name;


- (instancetype)initWithImageNamed:(NSString *)name
                   physicsFileName:(NSString*)fileName
                         directory:(NSString*)dir;


-(float)rotation;//returns z rotation in degrees
-(void)setRotation:(float)val;//set z rotation in degrees

-(void)setVisible:(BOOL)val;
-(BOOL)visible;

@end
