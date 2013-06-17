//
//  LoadSkeletonAnimationsScene.h
//  GameDevHelperAPI-SpriteKit
//

//  Copyright (c) 2013 Bogdan Vladu. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#import "GameDevHelper.h"

@interface LoadSkeletonAnimationsScene : SKScene
{
    GHSkeleton* skeleton;
    int currentAnim;
}
@end
