//
//  IpadRootViewController.m
//  How Is Underground
//
//  Created by Hooman Ostovari on 07/04/2014.
//  Copyright (c) 2014 Hooman Ostovari. All rights reserved.
//

#import "IpadRootViewController.h"
#import "JourneyPlannerViewController.h"

@implementation IpadRootViewController
{
    NSArray *rootViewPortraitConstraints;
    NSArray *tubeLinesPortraitConstraints;
    IBOutletCollection(NSLayoutConstraint)NSArray *tubeLinesLandscapeConstraints;
    IBOutletCollection(NSLayoutConstraint)NSArray *rootViewLandscapeConstraints;
    __weak IBOutlet UIView *viewContainer;
    __weak IBOutlet UIView *tubeLinesContainer;
//    TubeMapViewController* tubeMapViewController;
    JourneyPlannerViewController* journeyPlannerViewController;
}

#pragma mark - Init Functions

-(CGRect)initTubeMapFrame
{
    CGRect tubeMapFrame = viewContainer.bounds;
    [NSLogger log:[NSString stringWithFormat:@"x:%0.2f\t y:%0.2f\n width:%0.2f\t height:%0.2f",tubeMapFrame.origin.x,tubeMapFrame.origin.y,tubeMapFrame.size.width, tubeMapFrame.size.height]];
    tubeMapFrame.origin.x = 0.0;
    tubeMapFrame.origin.y = 0.0;
    return tubeMapFrame;
}

-(void)initPortraitConstraints
{
    if (rootViewPortraitConstraints != nil) {
        return;
    }
    id topGuide = self.topLayoutGuide;
    id bottomGuide = self.bottomLayoutGuide;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(tubeLinesContainer,viewContainer,topGuide,bottomGuide);
    NSMutableArray *tempRootViewConstraints = [NSMutableArray new];
    
    NSArray *generateConstraints = [NSLayoutConstraint
                                    constraintsWithVisualFormat:@"H:|-(0)-[viewContainer]-(0)-|"
                                    options:0
                                    metrics:nil
                                    views:views];
    [tempRootViewConstraints addObjectsFromArray:generateConstraints];
    generateConstraints = [NSLayoutConstraint
                           constraintsWithVisualFormat:@"H:|-(0)-[tubeLinesContainer]-(0)-|"
                           options:0
                           metrics:nil
                           views:views];
    [tempRootViewConstraints addObjectsFromArray:generateConstraints];
    
    generateConstraints = [NSLayoutConstraint
                           constraintsWithVisualFormat:@"V:[topGuide]-[tubeLinesContainer]-(0)-[viewContainer]-[bottomGuide]"
                           options:0
                           metrics:nil
                           views:views];
    [tempRootViewConstraints addObjectsFromArray:generateConstraints];
    
    rootViewPortraitConstraints = [NSArray arrayWithArray:tempRootViewConstraints];
    tubeLinesPortraitConstraints = [NSLayoutConstraint
                                    constraintsWithVisualFormat:@"V:[tubeLinesContainer(400)]"
                                    options:0
                                    metrics:nil
                                    views:views];
    
}

#pragma mark - ViewController Callbacks


-(void)viewDidLoad
{
    [super viewDidLoad];
    [self initPortraitConstraints];
    [self setConstraints:[[UIApplication sharedApplication] statusBarOrientation]];
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
        [viewContainer layoutIfNeeded];
    }
    
    journeyPlannerViewController  = [[JourneyPlannerViewController alloc] initWithNibName:@"JourneyPlannerViewController" bundle:[NSBundle mainBundle]];
    [self addChildViewController:journeyPlannerViewController];
    [viewContainer addSubview:journeyPlannerViewController.view];
    [journeyPlannerViewController didMoveToParentViewController:self];
    
//    tubeMapViewController = [[TubeMapViewController alloc] initWithNibName:@"TubeMapViewController" bundle:[NSBundle mainBundle]];
//    [self addChildViewController:tubeMapViewController];
//    tubeMapViewController.view.frame = [self initTubeMapFrame];
//    [tubeMapContainer addSubview:tubeMapViewController.view];
//    [tubeMapViewController didMoveToParentViewController:self];
    
}

-(void)viewWillAppear:(BOOL)animated
{
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];

}
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self setConstraints:toInterfaceOrientation];
}

#pragma mark - Utility functions

-(void) setConstraints:(UIInterfaceOrientation) orientation
{
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        [self.view removeConstraints:rootViewPortraitConstraints];
        [tubeLinesContainer removeConstraints:tubeLinesPortraitConstraints];
        [self.view addConstraints:rootViewLandscapeConstraints];
        [tubeLinesContainer addConstraints:tubeLinesLandscapeConstraints];
    } else {
        [self.view removeConstraints:rootViewLandscapeConstraints];
        [tubeLinesContainer removeConstraints:tubeLinesLandscapeConstraints];
        [self.view addConstraints:rootViewPortraitConstraints];
        [tubeLinesContainer addConstraints:tubeLinesPortraitConstraints];
    }
}

@end
