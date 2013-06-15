//
//  ViewController.m
//  GameDevHelperAPI-SpriteKit
//
//  Created by Bogdan Vladu on 6/14/13.
//  Copyright (c) 2013 Bogdan Vladu. All rights reserved.
//

#import "ViewController.h"
#import "LoadSimpleSpritesScene.h"

@interface ViewController ()
{
    NSArray* menuButtons;
}
@property (nonatomic) IBOutlet UIButton *backButton;
@property (nonatomic) IBOutlet UIButton *loadSpritesBut;
@property (nonatomic) IBOutlet UIButton *loadPhysicalSpritesBut;
@end


@implementation ViewController

-(void)hideMenuButtons:(BOOL)hide
{
    for(UIView* view in menuButtons)
    {
        [view setHidden:hide];
    }
}

-(void)goToScene{
    [self hideMenuButtons:YES];
    [_backButton setHidden:NO];
}

- (void)viewDidLoad
{
    menuButtons = @[_loadSpritesBut, _loadPhysicalSpritesBut];
    
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    [self backToMenu:nil];
}



-(IBAction)loadSpritesUsingSpriteKit:(id)sender
{
    SKView * skView = (SKView *)self.view;
    
    // Create and configure the scene.
    SKScene * scene = [LoadSimpleSpritesScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    [self goToScene];
    // Present the scene.
    [skView presentScene:scene];
}


-(IBAction)loadPhysicalSprites:(id)sender
{
//    SKView * skView = (SKView *)self.view;
//    
//    // Create and configure the scene.
//    SKScene * scene = [MyScene sceneWithSize:skView.bounds.size];
//    scene.scaleMode = SKSceneScaleModeAspectFill;
//    
//    [self goToScene];
//    // Present the scene.
//    [skView presentScene:scene];
}













-(IBAction)backToMenu:(id)sender
{
    SKView * skView = (SKView *)self.view;
    
    [skView presentScene:nil];
    [_backButton setHidden:YES];
    [self hideMenuButtons:NO];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
