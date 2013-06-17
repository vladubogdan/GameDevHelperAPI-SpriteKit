//
//  GHBoneSkin.m
//  cocos2d-ios
//
//  Created by Bogdan Vladu on 4/5/13.
//
//

#import "GHBoneSkin.h"
#import "GHBone.h"
#import "GHSprite.h"
#import "ghConfig.h"
#import "ghMacros.h"

@implementation GHBoneSkin
@synthesize positionOffset, angleOffset, connectionAngle, name, uuid;

-(id)initWithSprite:(GHSprite*)spr bone:(GHBone*)bn name:(NSString*)skinName uuid:(NSString*)skinUUID{

    self = [super init];
    if(self){
        sprite = spr;
        bone = bn;
        if(skinName)
            name = [[NSString alloc] initWithString:skinName];
        if(skinUUID)
            uuid = [[NSString alloc] initWithString:skinUUID];
    }
    return self;
}

+(id)skinWithSprite:(GHSprite*)spr bone:(GHBone*)bn name:(NSString*)skinName uuid:(NSString*)skinUUID{
    
#ifdef GH_ENABLE_ARC
    return [[self alloc] initWithSprite:spr bone:bn name:skinName uuid:skinUUID];
#else
    return [[[self alloc] initWithSprite:spr bone:bn name:skinName uuid:skinUUID] autorelease];
#endif
}

-(void)dealloc{
    GH_SAFE_RELEASE(name);
    GH_SAFE_RELEASE(uuid);
    GH_SAFE_RELEASE(bone);
    GH_SAFE_RELEASE(sprite);
    
#ifndef GH_ENABLE_ARC
    [super dealloc];
#endif
}

-(GHSprite*)sprite{
    return sprite;
}
-(void)setSprite:(GHSprite*)spr{
    sprite = spr;
}

-(GHBone*)bone{
    return bone;
}
-(void)setBone:(GHBone*)val{
    bone = val;
}

-(void)setupTransformations
{
    if(bone && sprite)
    {
        GHBone* _father = (GHBone*)[bone parent];
        
        
        angleOffset = 0;//needs to be calculated
        
        CGPoint bonePoint = _father.position;
        CGPoint currentPos = [sprite position];
        
        float curAngle = 360 - [sprite rotation];
        connectionAngle = curAngle;
        
        //we flip y for sprite kit
        CGPoint posOffset = CGPointMake(currentPos.x - bonePoint.x,
                                        bonePoint.y - currentPos.y);

        positionOffset = posOffset;
        
        float boneAngle = [bone degrees] ;
        
        angleOffset = boneAngle - curAngle;
    }
}

-(void)transform
{
    if(sprite == nil || bone == nil)return;
    
    float degrees = [bone degrees];
    
    CGPoint posOffset = positionOffset;
    
    CGPoint bonePos = CGPointMake(((GHBone*)[bone parent]).position.x,
                                  ((GHBone*)[bone parent]).position.y);
    
    
    CGAffineTransform transformOffset = CGAffineTransformTranslate(CGAffineTransformIdentity, bonePos.x, bonePos.y);
    
    
    CGAffineTransform transform = CGAffineTransformRotate(CGAffineTransformIdentity,
                                                          GH_DEGREES_TO_RADIANS(degrees - angleOffset));
    
    
    
    //we need 2 points
    //origin - upward point, in order to calculate new position and new angle
    CGPoint origin = CGPointMake(0,0);
    CGPoint upward = CGPointMake(0, -10);
    
    
    CGAffineTransform transform3 = CGAffineTransformRotate(CGAffineTransformIdentity,
                                                           GH_DEGREES_TO_RADIANS(degrees - angleOffset - connectionAngle));
    posOffset = CGPointApplyAffineTransform(posOffset, transform3);
    
    origin = CGPointApplyAffineTransform(origin, transform);
    upward = CGPointApplyAffineTransform(upward, transform);
    
    origin = CGPointApplyAffineTransform(origin, transformOffset);
    upward = CGPointApplyAffineTransform(upward, transformOffset);
    
    
    //now that we have the 2 points - lets calculate the angle
    float newAngle = (atan2(upward.y - origin.y,
                            upward.x - origin.x)*180.0)/M_PI + 90.0;
    

    [sprite setPosition:CGPointMake(origin.x + posOffset.x,
                                    origin.y - posOffset.y)];
    //[sprite setRotation:360 - newAngle];
    
    sprite.zRotation = (360 - newAngle) / 180.0 * M_PI;
    
}
@end
