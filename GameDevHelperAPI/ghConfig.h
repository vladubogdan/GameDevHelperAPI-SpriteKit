//
//  ghConfig.h
//  GameDevHelper.com
//
//  Created by Bogdan Vladu.
//  Copyright (c) 2013 Bogdan Vladu. All rights reserved.
//

#ifndef GAME_DEV_HELPER_API_ghConfig_h
#define GAME_DEV_HELPER_API_ghConfig_h


#if __has_feature(objc_arc) && __clang_major__ >= 3
#define GH_ENABLE_ARC 1
#endif // __has_feature(objc_arc)


#ifndef GH_ENABLE_ARC
    #define GH_SAFE_RELEASE(X) if(X){[X release]; X = nil;}
#else
    #define GH_SAFE_RELEASE(X) if(X){X = nil;}
#endif

/**
 Comment this line if you dont want debug drawing and logs.
 */
#define GH_DEBUG


#endif//GAME_DEV_HELPER_API_ghConfig_h
