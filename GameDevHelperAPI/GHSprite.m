//
//  GHSprite.m
//  GameDevHelperAPI-SpriteKit
//
//  Created by Bogdan Vladu on 6/17/13.
//  Copyright (c) 2013 Bogdan Vladu. All rights reserved.
//

#import "GHSprite.h"
#import "GameDevHelper.h"
#import "ghMacros.h"
@implementation GHSprite

- (instancetype)initWithImageNamed:(NSString *)name{
    self = [super initWithImageNamed:name];
    if(self){
        
    }
    return self;
}

- (instancetype)initWithImageNamed:(NSString *)name
                   physicsFileName:(NSString*)fileName
                         directory:(NSString*)dir{
    
    self = [super initWithImageNamed:name];
    if(self){
        
        
//        float scale = [[UIScreen mainScreen] scale];
//        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//        {
//            if( scale == 2 ){//retina ipad
//                fileName = [fileName stringByAppendingString:@"@4x"];
//            }
//            else{//normal ipad
//                fileName = [fileName stringByAppendingString:@"@2x"];
//            }
//        }
//        else
//        {
//            if( scale == 2 ){ //retina iphone
//                fileName = [fileName stringByAppendingString:@"@2x"];
//            }
//            else{//normal iphone
//                //nothing to do - leave as it is
//            }
//        }
        
        
        
        
        NSString* path = [[NSBundle mainBundle] pathForResource:fileName
                                                         ofType:@"plist"
                                                    inDirectory:dir];
        
        NSDictionary* physicsDict = [NSDictionary dictionaryWithContentsOfFile:path];
        
        NSDictionary* pinfo = [physicsDict objectForKey:name];
        if(pinfo){
            physicsInfo = [[NSDictionary alloc] initWithDictionary:pinfo];
            [self createBody];
        }
    }
    
    return self;
}

-(void)dealloc{
    
#ifndef GH_ENABLE_ARC
    [physicsInfo release];
#endif
    
    physicsInfo = nil;
    
    
    
#ifndef GH_ENABLE_ARC
    [super dealloc];
#endif
}


+ (instancetype)spriteNodeWithImageNamed:(NSString *)name{
#ifdef GH_ENABLE_ARC
    return [[self alloc] initWithImageNamed:name];
#else
    return [[[self alloc] initWithImageNamed:name] autorelease];
#endif
}

+ (instancetype)spriteNodeWithImageNamed:(NSString *)name
                         physicsFileName:(NSString*)filePath
                               directory:(NSString*)dir
{
#ifdef GH_ENABLE_ARC
    return [[self alloc] initWithImageNamed:name physicsFileName:filePath directory:dir];
#else
    return [[[self alloc] initWithImageNamed:name physicsFileName:filePath directory:dir] autorelease];
#endif
}


-(float)rotation{
    return GH_RADIANS_TO_DEGREES(self.zRotation);
}

-(void)setRotation:(float)val{
    self.zRotation = GH_DEGREES_TO_RADIANS(val);
}


-(void)setVisible:(BOOL)val{
    [self setHidden:!val];
}
-(BOOL)visible{
    return self.isHidden;
}



-(void)destroyBody{
    if(self.physicsBody)
    {
#ifndef GH_ENABLE_ARC
        [self.physicsBody release];
#endif
        self.physicsBody = nil;
    }
}

-(void)createBody{
    
    if(physicsInfo == nil)return;
    
    [self destroyBody];
        

    NSArray* shapesInfo = [physicsInfo objectForKey:@"shapes"];
    for(NSDictionary* shInfo in shapesInfo)
    {
        float density = [[shInfo objectForKey:@"density"]floatValue];
        float friction = [[shInfo objectForKey:@"friction"]floatValue];
        float restitution = [[shInfo objectForKey:@"restitution"]floatValue];
//        bool sensor = [[shInfo objectForKey:@"sensor"]boolValue];
        //        <key>name</key>
        //        <string>backpackShape</string>
        //        <key>sensor</key>
        //        <false/>
        //        <key>shapeID</key>
        //        <integer>0</integer>
        //
        
        int type = [[shInfo objectForKey:@"type"] intValue];
        
        if(type == 2) //CIRCLE
        {
            float circleRadius = [[shInfo objectForKey:@"radius"] floatValue];
//            NSString* offsetStr = [shInfo objectForKey:@"circleOffset"];
//            CGPoint offset = CGPointFromString(offsetStr);
            
            self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:circleRadius/2.0f];
    
            
            self.physicsBody.friction = friction;
            self.physicsBody.restitution = restitution;
            self.physicsBody.density = density;
            
//            circle.m_p = GH_POINT_TO_METERS(offset);
            
            NSNumber* cat = [shInfo objectForKey:@"category"];
            NSNumber* mask = [shInfo objectForKey:@"mask"];
            
            if(cat && mask)
            {
                self.physicsBody.categoryBitMask  = [cat intValue];
                self.physicsBody.collisionBitMask = [mask intValue];
            }
        }
        else{//create using points
            
            NSArray* fixtures = [shInfo objectForKey:@"fixtures"];
            bool firstFixtureNode = true;
            for(NSArray* fixPoints in fixtures)
            {
                int count = (int)[fixPoints count];
                CGPoint points[count];
                
                int i = count - 1;
                for(int j = 0; j< count; ++j)
                {
                    NSString* pointStr = [fixPoints objectAtIndex:(NSUInteger)j];
                    CGPoint point = CGPointFromString(pointStr);

                    point.x *=2;
                    point.y *=2;
                    
                    //flip y for sprite kit coordinate system
                    point.y =  self.size.height - point.y;
                    point.y = point.y - self.size.height;

                    points[j] = point;
                    i = i-1;
                }
                

                CGMutablePathRef fixPath =  CGPathCreateMutable();
                
                bool first = true;
                for(int k = 0; k < count; ++k)
                {
                    CGPoint point = points[k];
                    if(first){
                        CGPathMoveToPoint(fixPath, nil, point.x, point.y);
                    }
                    else{
                        CGPathAddLineToPoint(fixPath, nil, point.x, point.y);
                    }
                    first = false;
                }
                
                
                SKNode* fixtureNode = self;
                if(!firstFixtureNode){
//                    fixtureNode = [SKNode node];
                    fixtureNode = [SKShapeNode node];
                    [(SKShapeNode*)fixtureNode setPath:fixPath];
                }
                firstFixtureNode = false;
                
                
                
                fixtureNode.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:fixPath];
                
                fixtureNode.physicsBody.friction = friction;
                fixtureNode.physicsBody.restitution = restitution;
                fixtureNode.physicsBody.density = density;
                
                NSNumber* cat = [shInfo objectForKey:@"category"];
                NSNumber* mask = [shInfo objectForKey:@"mask"];
                
                if(cat && mask)
                {
                    fixtureNode.physicsBody.categoryBitMask  = [cat intValue];
                    fixtureNode.physicsBody.collisionBitMask = [mask intValue];
                }
                
                int type = [[physicsInfo objectForKey:@"type"] intValue];
                if(type == 3)//NO PHYSICS
                    return;
                
                fixtureNode.physicsBody.dynamic = NO;
                if(type == 2)//dynamic
//                    fixtureNode.physicsBody.dynamic = YES;
                
                fixtureNode.physicsBody.allowsRotation = ![[physicsInfo objectForKey:@"fixed"] boolValue];

                if(self != fixtureNode)
                    [self addChild:fixtureNode];

                NSLog(@"DID ADD FIXTURE NODE body %p %d", fixtureNode.physicsBody, fixtureNode.physicsBody.dynamic);

            }
        }
    }
    
    if(self.physicsBody){
        int type = [[physicsInfo objectForKey:@"type"] intValue];
        if(type == 3)//NO PHYSICS
            return;
        
        self.physicsBody.dynamic = NO;
        if(type == 2)//dynamic
            self.physicsBody.dynamic = YES;
        
        self.physicsBody.allowsRotation = ![[physicsInfo objectForKey:@"fixed"] boolValue];
    }
//    @property (SK_NONATOMIC_IOSONLY) CGFloat mass;
//    @property (SK_NONATOMIC_IOSONLY, assign) uint32_t categoryBitMask;
//    @property (SK_NONATOMIC_IOSONLY, assign) uint32_t collisionBitMask;
//    @property (SK_NONATOMIC_IOSONLY, assign) uint32_t contactTestBitMask;

    
//    body->SetGravityScale([[physicsInfo objectForKey:@"gravityScale"] floatValue]);
//	  body->SetSleepingAllowed([[physicsInfo objectForKey:@"sleep"] boolValue]);
//    body->SetBullet([[physicsInfo objectForKey:@"bullet"] boolValue]);
//    body->SetAwake([[physicsInfo objectForKey:@"awake"] boolValue]);
//    body->SetActive([[physicsInfo objectForKey:@"active"] boolValue]);
    

}
@end
