//
//  LoadSkeletonPosesScene.h
//  GameDevHelperAPI-SpriteKit
//

//  Copyright (c) 2013 Bogdan Vladu. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#import "GameDevHelper.h"

@interface LoadSkeletonPosesScene : SKScene
{
    GHSkeleton* skeleton;
    int currentPose;
}
@end
