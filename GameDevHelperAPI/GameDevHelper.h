//
//  GameDevHelper.h
//  GameDevHelperAPI-SpriteKit
//
//  Created by Bogdan Vladu on 6/17/13.
//  Copyright (c) 2013 Bogdan Vladu. All rights reserved.
//

#ifndef GameDevHelperAPI_SpriteKit_GameDevHelper_h
#define GameDevHelperAPI_SpriteKit_GameDevHelper_h


// 0x00 HI ME LO
// 00   02 01 00
/**
 The version of the API. Use this in order to support multiple versions of the api in your code.
 
 @code
 #if GAME_DEV_HELPER_API_VERSION == 0x00010000
 //do something
 #else
 //do something else
 #endif
 @endcode
 */
#define GAME_DEV_HELPER_API_VERSION 0x00010000


// all GameDevHelepr API include files
#import "ghConfig.h"	//should be included first
#import "ghMacros.h"
#import "GHSprite.h"

#import "GHSkeleton.h"
#import "GHSkeletalAnimationCache.h"
#import "GHSkeletalAnimation.h"
//#import "GHDirector.h"
//#import "GHDebugDrawLayer.h"
//#import "GHDirector.h"

//#import "GHAnimationCache.h"
//#import "GHAnimation.h"


#endif
