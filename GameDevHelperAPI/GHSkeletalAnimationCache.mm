//
//  GHSkeletalAnimationCache.m
//  cocos2d-ios
//
//  Created by Bogdan Vladu on 4/8/13.
//
//

#import "GHSkeletalAnimationCache.h"
#import "GHSkeletalAnimation.h"
#import "ghConfig.h"

@interface GHSkeletalAnimationCache ()
- (void) addSkeletalAnimationWithDictionary:(NSDictionary*)dictionary;
@end


@implementation GHSkeletalAnimationCache


#pragma mark GHSkeletalAnimationCache - Alloc, Init & Dealloc

static GHSkeletalAnimationCache *sharedSkeletalAnimationCache_=nil;

+ (GHSkeletalAnimationCache *)sharedSkeletalAnimationCache
{
	if (!sharedSkeletalAnimationCache_)
		sharedSkeletalAnimationCache_ = [[GHSkeletalAnimationCache alloc] init];
    
	return sharedSkeletalAnimationCache_;
}

+(id)alloc
{
	NSAssert(sharedSkeletalAnimationCache_ == nil, @"Attempted to allocate a second instance of a singleton.");
	return [super alloc];
}

+(void)purgeSharedSkeletalAnimationCache
{
    GH_SAFE_RELEASE(sharedSkeletalAnimationCache_);
}

-(id) init
{
	if( (self=[super init]) ) {
		skeletalAnimations_ = [[NSMutableDictionary alloc] initWithCapacity: 10];
		loadedFilenames_ = [[NSMutableSet alloc] initWithCapacity:30];
	}
    
	return self;
}

- (NSString*) description
{
	return [NSString stringWithFormat:@"<%@ = %p | num of sprite frames =  %lu>", [self class], self, (unsigned long)[skeletalAnimations_ count]];
}

-(void) dealloc
{
    GH_SAFE_RELEASE(skeletalAnimations_);
    GH_SAFE_RELEASE(loadedFilenames_);
    
#ifndef GH_ENABLE_ARC
	[super dealloc];
#endif
}


-(void) addSkeletalAnimationWithFile:(NSString*)plist{

    NSAssert(plist, @"plist filename should not be nil");
	
	if( ! [loadedFilenames_ member:plist] ) {
        
//		NSString *path = [[CCFileUtils sharedFileUtils] fullPathFromRelativePath:plist];
//		NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];

//        [self addSkeletalAnimationWithDictionary:dict];
		
		[loadedFilenames_ addObject:plist];
	}
	else
		NSLog(@"GameDevHelper: GHSkeletalAnimationCache: file already loaded: %@", plist);

}

- (void) addSkeletalAnimationWithDictionary:(NSDictionary*)dictionary{
    if(nil == dictionary)return;
    GHSkeletalAnimation* anim = [GHSkeletalAnimation animationWithDictionary:dictionary];
    [skeletalAnimations_ setObject:anim forKey:anim.name];
}

-(void) removeSkeletalAnimations{
    
    [skeletalAnimations_ removeAllObjects];
	[loadedFilenames_ removeAllObjects];
}

-(void) removeUnusedSkeletalAnimations{
    
//	NSArray *keys = [skeletalAnimations_ allKeys];
//	for( id key in keys ) {
//		id value = [skeletalAnimations_ objectForKey:key];
//		if( [value retainCount] == 1 ) {
//			NSLog(@"GameDevHelper: GHSkeletalAnimationCache: removing unused frame: %@", key);
//            
//			[skeletalAnimations_ removeObjectForKey:key];
//		}
//	}
}

-(void) removeSkeletalAnimationWithName:(NSString*)name{
    
    // explicit nil handling
	if( ! name )
		return;
    
    [skeletalAnimations_ removeObjectForKey:name];
	
	// XXX. Since we don't know the .plist file that originated the frame, we must remove all .plist from the cache
	[loadedFilenames_ removeAllObjects];
}

-(GHSkeletalAnimation*) skeletalAnimationWithName:(NSString*)name{
    
    GHSkeletalAnimation *anim = [skeletalAnimations_ objectForKey:name];
	if( ! anim ) {
        NSLog(@"GameDevHelper: GHSkeletalAnimationCache: Animation '%@' not found", name);
	}

	return anim;
}

@end
