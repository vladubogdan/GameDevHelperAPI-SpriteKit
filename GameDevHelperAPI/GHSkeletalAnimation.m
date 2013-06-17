//
//  GHSkeletalAnimation.m
//  spritekit
//
//  Created by Bogdan Vladu on 4/8/13.
//
//

#import "GHSkeletalAnimation.h"
#import "ghConfig.h"


@implementation GHSkeletalSkinConnectionInfo

@synthesize boneName, angleOffset, connectionAngle, positionOffset;
@synthesize position, angle;

-(id)initWithBoneName:(NSString*)name{
    self = [super init];
    if(self){
        if(name){
            boneName = [[NSString alloc] initWithString:name];
        }
    }
    return self;
}
-(void)dealloc{
    
#ifndef GH_ENABLE_ARC
    [boneName release];
#endif
    boneName = nil;
    
    
#ifndef GH_ENABLE_ARC
    [super dealloc];
#endif
}

+(id)skinConnectionInfoWithBoneName:(NSString*)name{
#ifdef GH_ENABLE_ARC
    return [[self alloc] initWithBoneName:name];
#else
    return [[[self alloc] initWithBoneName:name] autorelease];
#endif
}
@end





@implementation GHSkeletalAnimationFrame
@synthesize time = time_;


-(id) initWithTime:(float)tm{

    self = [super init];
    if(self){
        time_ = tm;
        
        bonePositions_ = nil;
        spritesZOrder_ = nil;
        skinConnections_ = nil;
        skinSprites_ = nil;
        spritesVisibility_ = nil;
        spritesTransform_ = nil;
    }
    return self;
}

+(id) frameWithTime:(float)tm{
#ifdef GH_ENABLE_ARC
    return [[self alloc] initWithTime:tm];
#else
    return [[[self alloc] initWithTime:tm] autorelease];
#endif
}

-(void)dealloc{
    
    GH_SAFE_RELEASE(bonePositions_);
    GH_SAFE_RELEASE(spritesZOrder_);
    GH_SAFE_RELEASE(skinConnections_);
    GH_SAFE_RELEASE(skinSprites_);
    GH_SAFE_RELEASE(spritesVisibility_);
    GH_SAFE_RELEASE(spritesTransform_);
    
#ifndef GH_ENABLE_ARC
    [super dealloc];
#endif
}

-(void)setBonePositionsWithDictionary:(NSDictionary*)bones{
    
    if(nil == bones)return;
    
    GH_SAFE_RELEASE(bonePositions_);
    
    bonePositions_ = [[NSMutableDictionary alloc] init];
    
    
    NSArray* keys = [bones allKeys];
    for(NSString* boneName in keys){
        NSString* bonePos = [bones objectForKey:boneName];
        if(bonePos){
            CGPoint position = CGPointFromString(bonePos);
            [bonePositions_ setObject:[NSValue valueWithCGPoint:position] forKey:boneName];
        }
    }
}

-(void)setSpritesZOrderWithDictionary:(NSDictionary*)sprites
{
    if(nil == sprites)return;
    
    GH_SAFE_RELEASE(spritesZOrder_);
    
    spritesZOrder_ = [[NSMutableDictionary alloc] initWithDictionary:sprites];    
}

-(void)setSkinConnectionsWithDictionary:(NSDictionary*)connections
{
    if(nil == connections)return;
    
    GH_SAFE_RELEASE(skinConnections_);
    
    skinConnections_ = [[NSMutableDictionary alloc] init];
    
    NSArray* keys = [connections allKeys];
    for(NSString* sprName in keys){
        NSDictionary* connectionInfo = [connections objectForKey:sprName];
        if(connectionInfo){
            
            NSString* boneName = [connectionInfo objectForKey:@"bone"];
            float angleOff = [[connectionInfo objectForKey:@"angleOff"] floatValue];
            float connAngle = [[connectionInfo objectForKey:@"connAngle"] floatValue];
            CGPoint posOff = CGPointFromString([connectionInfo objectForKey:@"posOff"]);
            //posOff.x /= CC_CONTENT_SCALE_FACTOR();
            //posOff.y /= CC_CONTENT_SCALE_FACTOR();

            GHSkeletalSkinConnectionInfo* skinInfo = [GHSkeletalSkinConnectionInfo skinConnectionInfoWithBoneName:boneName];
            [skinInfo setAngleOffset:angleOff];
            [skinInfo setConnectionAngle:connAngle];
            [skinInfo setPositionOffset:posOff];
            
            [skinConnections_ setObject:skinInfo
                                 forKey:sprName];
        }
    }
}

-(void)setSkinSpritesWithDictionary:(NSDictionary*)dictionary
{
    if(nil == dictionary)return;
    
    GH_SAFE_RELEASE(skinSprites_);
    
    skinSprites_ = [[NSMutableDictionary alloc] initWithDictionary:dictionary];
}

-(void)setSpritesVisibilityWithDictionary:(NSDictionary*)dictionary
{
    if(nil == dictionary)return;
    
    GH_SAFE_RELEASE(spritesVisibility_);
    
    spritesVisibility_ = [[NSMutableDictionary alloc] initWithDictionary:dictionary];
}

-(void)setSpritesTransformWithDictionary:(NSDictionary*)dictionary
{
    if(nil == dictionary)return;
    
    GH_SAFE_RELEASE(spritesTransform_);
    
    spritesTransform_ = [[NSMutableDictionary alloc] init];
    
    NSArray* keys = [dictionary allKeys];
    for(NSString* sprName in keys){
        NSDictionary* transformInfo = [dictionary objectForKey:sprName];
        if(transformInfo){
            
            float angleOff = [[transformInfo objectForKey:@"angleOff"] floatValue];
            float connAngle = [[transformInfo objectForKey:@"connAngle"] floatValue];
            CGPoint posOff = CGPointFromString([transformInfo objectForKey:@"posOff"]);
            //posOff.x /= CC_CONTENT_SCALE_FACTOR();
            //posOff.y /= CC_CONTENT_SCALE_FACTOR();
            
            float angle = [[transformInfo objectForKey:@"angle"] floatValue];
            CGPoint position = CGPointFromString([transformInfo objectForKey:@"position"]);
            //position.x /= CC_CONTENT_SCALE_FACTOR();
            //position.y /= CC_CONTENT_SCALE_FACTOR();
            
            GHSkeletalSkinConnectionInfo* transform = [GHSkeletalSkinConnectionInfo skinConnectionInfoWithBoneName:nil];
            [transform setAngleOffset:angleOff];
            [transform setConnectionAngle:connAngle];
            [transform setPositionOffset:posOff];
            
            [transform setAngle:angle];
            [transform setPosition:position];
            
            [spritesTransform_ setObject:transform
                                  forKey:sprName];
        }
    }
}

-(NSMutableDictionary*)bonePositions{
    return bonePositions_;
}

-(NSMutableDictionary*)spritesZOrder{
    return spritesZOrder_;
}

-(NSMutableDictionary*)skinConnections{
    return skinConnections_;
}

-(NSMutableDictionary*)skinSprites{
    return skinSprites_;
}

-(NSMutableDictionary*)spritesVisibility{
    return spritesVisibility_;
}
-(NSMutableDictionary*)spritesTransform{
    return spritesTransform_;
}
@end






@implementation GHSkeletalAnimation
@synthesize name = name_;
@synthesize numberOfLoops = numberOfLoops_;
@synthesize currentLoop = currentLoop_;
@synthesize playMode = playMode_;
@synthesize reversed = reversed_;
@synthesize paused = paused_;

-(id)initWithFileName:(NSString*)fileName inDirectory:(NSString*)dirName{
    

    NSString* filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist" inDirectory:dirName];
    
    if(filePath){
        
        NSDictionary* dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
        if(dict){
            return [self initWithDictionary:dict];
        }
    }
    return nil;
}

+(id)animationWithFileName:(NSString*)fileName inDirectory:(NSString*)dirName{
#ifdef GH_ENABLE_ARC
    return [[self alloc] initWithFileName:fileName inDirectory:dirName];
#else
    return [[[self alloc] initWithFileName:fileName inDirectory:dirName] autorelease];
#endif
}


-(id) initWithDictionary:(NSDictionary*)dict{
    self = [super init];
    if(self){
                
        bonePositionFrames_ = [[NSMutableArray alloc] init];
        spriteZOrderFrames_ = [[NSMutableArray alloc] init];
        skinConnectionFrames_ = [[NSMutableArray alloc] init];
        skinSpriteFrames_ = [[NSMutableArray alloc] init];
        visibilityFrames_ = [[NSMutableArray alloc] init];
        spritesTransformFrames_ = [[NSMutableArray alloc] init];
        
        paused_ = false;
        currentTime_ = 0;
        numberOfLoops_ = 0;
        currentLoop_ = 0;
        reversed_ = false;
        
        NSString* dictAnimName = [dict objectForKey:@"name"];
        if(dictAnimName)
        {
            name_ = [[NSString alloc] initWithString:[dict objectForKey:@"name"]];
        }
        else{
#ifndef GH_ENABLE_ARC
            name_ = [[NSString alloc] initWithString:@"UntitledAnimation"];
#else
            name_ = @"UntitledAnimation";
#endif
        }

        totalTime_ = [[dict objectForKey:@"totalTime"] floatValue];
        
        playMode_ = [[dict objectForKey:@"playMode"] intValue];
        
        {//setting bone positions
            NSArray* posFrames = [dict objectForKey:@"positionFrames"];
            for(NSDictionary* frmInfo in posFrames){
                
                float frmTime = [[frmInfo objectForKey:@"time"] floatValue];
                
                GHSkeletalAnimationFrame* frm = [GHSkeletalAnimationFrame frameWithTime:frmTime];
                [frm setBonePositionsWithDictionary:[frmInfo objectForKey:@"bones"]];
     
                [bonePositionFrames_ addObject:frm];
            }
        }
        
        
        {//setting sprites z order
            NSArray* zOrderFrames = [dict objectForKey:@"zOrderFrames"];
            for(NSDictionary* frmInfo in zOrderFrames)
            {
                float frmTime = [[frmInfo objectForKey:@"time"] floatValue];
                
                GHSkeletalAnimationFrame* frm = [GHSkeletalAnimationFrame frameWithTime:frmTime];
                [frm setSpritesZOrderWithDictionary:[frmInfo objectForKey:@"sprites"]];
                [spriteZOrderFrames_ addObject:frm];
            }
        }
        
        {//setting skin connection frames
            NSArray* connectionFrames = [dict objectForKey:@"connectionFrames"];
            for(NSDictionary* frmInfo in connectionFrames)
            {
                float frmTime = [[frmInfo objectForKey:@"time"] floatValue];
                
                GHSkeletalAnimationFrame* frm = [GHSkeletalAnimationFrame frameWithTime:frmTime];
                [frm setSkinConnectionsWithDictionary:[frmInfo objectForKey:@"connections"]];
                [skinConnectionFrames_ addObject:frm];
            }
        }
        
        {//setting skin sprite frames
            NSArray* skinFrames = [dict objectForKey:@"skinFrames"];
            for(NSDictionary* frmInfo in skinFrames)
            {
                float frmTime = [[frmInfo objectForKey:@"time"] floatValue];
                
                GHSkeletalAnimationFrame* frm = [GHSkeletalAnimationFrame frameWithTime:frmTime];
                
                [frm setSkinSpritesWithDictionary:[frmInfo objectForKey:@"skins"]];
                [skinSpriteFrames_ addObject:frm];
            }            
        }

        {//setting sprite visibility frames
            NSArray* skinFrames = [dict objectForKey:@"visibilityFrames"];
            for(NSDictionary* frmInfo in skinFrames)
            {
                float frmTime = [[frmInfo objectForKey:@"time"] floatValue];
                
                GHSkeletalAnimationFrame* frm = [GHSkeletalAnimationFrame frameWithTime:frmTime];
                
                [frm setSpritesVisibilityWithDictionary:[frmInfo objectForKey:@"sprites"]];
                [visibilityFrames_ addObject:frm];
            }
        }
        
        {//setting sprite transform frames
            NSArray* transformFrames = [dict objectForKey:@"spriteTransformFrames"];
            for(NSDictionary* frmInfo in transformFrames)
            {
                float frmTime = [[frmInfo objectForKey:@"time"] floatValue];
                
                GHSkeletalAnimationFrame* frm = [GHSkeletalAnimationFrame frameWithTime:frmTime];
                
                [frm setSpritesTransformWithDictionary:[frmInfo objectForKey:@"transform"]];
                [spritesTransformFrames_ addObject:frm];
            }
        }

    }
    return self;
}

+(id) animationWithDictionary:(NSDictionary*)dict{
    
#ifdef GH_ENABLE_ARC
    return [[self alloc] initWithDictionary:dict];
#else
    return [[[self alloc] initWithDictionary:dict] autorelease];
#endif
    
}

-(void)dealloc{

	NSLog(@"GameDevHelper: deallocing %@",self);
        
    GH_SAFE_RELEASE(bonePositionFrames_);
    GH_SAFE_RELEASE(spriteZOrderFrames_);
    GH_SAFE_RELEASE(skinConnectionFrames_);
    GH_SAFE_RELEASE(skinSpriteFrames_);
    GH_SAFE_RELEASE(visibilityFrames_);
    GH_SAFE_RELEASE(spritesTransformFrames_);
    

#ifndef GH_ENABLE_ARC
    [super dealloc];
#endif
}

-(void)setTotalTime:(float)newTime{
    
    if(newTime < 0.1)
        newTime = 0.1;
    
    float currentTotalTime = totalTime_;
    
    [self changeTimeForFrames:bonePositionFrames_
                  currentTime:currentTotalTime
                 newTotalTime:newTime];
    
    [self changeTimeForFrames:spriteZOrderFrames_
                  currentTime:currentTotalTime
                 newTotalTime:newTime];
    
    [self changeTimeForFrames:skinConnectionFrames_
                  currentTime:currentTotalTime
                 newTotalTime:newTime];

    [self changeTimeForFrames:skinSpriteFrames_
                  currentTime:currentTotalTime
                 newTotalTime:newTime];

    [self changeTimeForFrames:visibilityFrames_
                  currentTime:currentTotalTime
                 newTotalTime:newTime];

    [self changeTimeForFrames:spritesTransformFrames_
                  currentTime:currentTotalTime
                 newTotalTime:newTime];

    
    totalTime_ = newTime;
}
-(void)changeTimeForFrames:(NSMutableArray*)frames
               currentTime:(float)currentTotalTime
              newTotalTime:(float)newTime
{
    for(GHSkeletalAnimationFrame* frame in frames)
    {
        float currentFrameTime = [frame time];
        float frameUnit = currentFrameTime/currentTotalTime;
        //gives a value between 0 and 1 for the frame time
        //multiplying this unit value with the new total time gives use the new frame time
        float newFrameTime = frameUnit*newTime;
        [frame setTime:newFrameTime];
    }    
}

-(float)totalTime{
    return totalTime_;
}

-(void)setCurrentTime:(float)val{
    if(!paused_){
        currentTime_ = val;
    }
}
-(float)currentTime{
    return currentTime_;
}

-(NSMutableArray*)bonePositionFrames{
    return bonePositionFrames_;
}
-(NSMutableArray*)spriteZOrderFrames{
    return spriteZOrderFrames_;
}
-(NSMutableArray*)skinConnectionFrames{
    return skinConnectionFrames_;
}
-(NSMutableArray*)skinSpriteFrames{
    return skinSpriteFrames_;
}
-(NSMutableArray*)visibilityFrames{
    return visibilityFrames_;
}
-(NSMutableArray*)spritesTransformFrames{
    return spritesTransformFrames_;
}

-(int)goToNextBonePositionFrame{
    return [self goToNextFrameUsingFramesArray:[self bonePositionFrames]];
}
-(int)goToPreviousBonePositionFrame{
    return [self goToPreviousFrameUsingFramesArray:[self bonePositionFrames]];
}

-(int)goToNextSpriteZOrderFrame{
    return [self goToNextFrameUsingFramesArray:[self spriteZOrderFrames]];
}
-(int)goToPreviousSpriteZOrderFrame{
    return [self goToPreviousFrameUsingFramesArray:[self spriteZOrderFrames]];
}


-(int)goToNextSkinConnectionFrame{
    return [self goToNextFrameUsingFramesArray:[self skinConnectionFrames]];
}
-(int)goToPreviousSkinConnectionFrame{
    return [self goToPreviousFrameUsingFramesArray:[self skinConnectionFrames]];
}


-(int)goToNextSkiSpriteFrame{
    return [self goToNextFrameUsingFramesArray:[self skinSpriteFrames]];
}
-(int)goToPreviousSkinSpriteFrame{
    return [self goToPreviousFrameUsingFramesArray:[self skinSpriteFrames]];
}


-(int)goToNextVisibilityFrame{
    return [self goToNextFrameUsingFramesArray:[self visibilityFrames]];
}
-(int)goToPreviousVisibilityFrameFrame{
    return [self goToPreviousFrameUsingFramesArray:[self visibilityFrames]];
}


-(int)goToNextSpriteTransformFrame{
    return [self goToNextFrameUsingFramesArray:[self spritesTransformFrames]];
}
-(int)goToPreviousSpriteTransformFrame{
    return [self goToPreviousFrameUsingFramesArray:[self spritesTransformFrames]];
}





-(int)goToNextFrameUsingFramesArray:(NSMutableArray*)array{
    
    GHSkeletalAnimationFrame* currentFrame = nil;
    for(GHSkeletalAnimationFrame* frm in array){
        
        if([frm time] <= currentTime_){
            currentFrame = frm;
        }
    }
    
    if(currentFrame){
        int idx = [array indexOfObject:currentFrame];
        ++idx;
        if(idx >= [array count]){
            idx = [array count]-1;
        }
        GHSkeletalAnimationFrame* nextFrame = [array objectAtIndex:idx];
        currentTime_ = [nextFrame time];
        
        return idx;
    }
    
    return -1;
}

-(int)goToPreviousFrameUsingFramesArray:(NSMutableArray*)array
{
    
    GHSkeletalAnimationFrame* currentFrame = nil;
    for(GHSkeletalAnimationFrame* frm in array){
        
        if([frm time] <= currentTime_){
            currentFrame = frm;
        }
    }
    
    if(currentFrame){
        int idx = [array indexOfObject:currentFrame];
        --idx;
        if(idx <0){
            idx = 0;
        }
        GHSkeletalAnimationFrame* nextFrame = [array objectAtIndex:idx];
        currentTime_ = [nextFrame time];
        return idx;
    }
    return -1;
}


- (id)copyWithZone:(NSZone *)zone
{
	GHSkeletalAnimation *animation  = [[[self class] allocWithZone: zone] initWithPositionFrames:bonePositionFrames_
                                                                              spriteZOrderFrames:spriteZOrderFrames_
                                                                                 skinConnections:skinConnectionFrames_
                                                                                     skinSprites:skinSpriteFrames_
                                                                                visibilityFrames:visibilityFrames_
                                                                          spritesTransformFrames:spritesTransformFrames_
                                                                                       totalTime:totalTime_
                                                                                            name:name_];
    [animation setNumberOfLoops:numberOfLoops_];
    [animation setCurrentLoop:currentLoop_];
    [animation setPlayMode:playMode_];
    [animation setCurrentTime:currentTime_];
    [animation setReversed:reversed_];
	return animation;
}

-(id) initWithPositionFrames:(NSArray*)positionFramesArray
          spriteZOrderFrames:(NSArray*)zOrderFramesArray
             skinConnections:(NSArray*)skinConnectionsArray
                 skinSprites:(NSArray*)skinSpritesArray
            visibilityFrames:(NSArray*)visibilityFramesArray
      spritesTransformFrames:(NSArray*)spriteTransformFramesArray
                   totalTime:(float)time
                        name:(NSString*)animName{
    self = [super init];
    if(self){
        if(positionFramesArray){
            bonePositionFrames_ = [[NSMutableArray alloc] initWithArray:positionFramesArray];
        }
        
        if(zOrderFramesArray){
            spriteZOrderFrames_ = [[NSMutableArray alloc] initWithArray:zOrderFramesArray];
        }
        
        if(skinConnectionsArray){
            skinConnectionFrames_ = [[NSMutableArray alloc] initWithArray:skinConnectionsArray];
        }
        
        if(skinSpritesArray){
            skinSpriteFrames_ =[[NSMutableArray alloc] initWithArray:skinSpritesArray];
        }
        if(visibilityFramesArray){
            visibilityFrames_ = [[NSMutableArray alloc] initWithArray:visibilityFramesArray];
        }
        if(spriteTransformFramesArray){
            spritesTransformFrames_ = [[NSMutableArray alloc] initWithArray:spriteTransformFramesArray];
        }
        totalTime_ = time;
        name_ = [[NSString alloc] initWithString:animName];
    }
    return self;
}

@end


