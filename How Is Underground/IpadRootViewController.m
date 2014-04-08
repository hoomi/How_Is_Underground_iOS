//
//  IpadRootViewController.m
//  How Is Underground
//
//  Created by Hooman Ostovari on 07/04/2014.
//  Copyright (c) 2014 Hooman Ostovari. All rights reserved.
//

#import "IpadRootViewController.h"

@implementation IpadRootViewController
{
    NSArray *rootViewPortraitConstraints;
    NSArray *tubeLinesPortraitConstraints;
    IBOutletCollection(NSLayoutConstraint)NSArray *tubeLinesLandscapeConstraints;
    IBOutletCollection(NSLayoutConstraint)NSArray *rootViewLandscapeConstraints;
    __weak IBOutlet UIView *tubeMapContainer;
    __weak IBOutlet UIView *tubeLinesContainer;
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    [self initPortraitConstraints];
    [self setConstraints:[[UIApplication sharedApplication] statusBarOrientation]];
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
-(void)initPortraitConstraints
{
    if (rootViewPortraitConstraints != nil) {
        return;
    }
    id topGuide = self.topLayoutGuide;
    id bottomGuide = self.bottomLayoutGuide;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(tubeLinesContainer,tubeMapContainer,topGuide,bottomGuide);
    NSMutableArray *tempRootViewConstraints = [NSMutableArray new];
    
    NSArray *generateConstraints = [NSLayoutConstraint
                                    constraintsWithVisualFormat:@"H:|-(0)-[tubeMapContainer]-(0)-|"
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
                           constraintsWithVisualFormat:@"V:[topGuide]-[tubeMapContainer]-[tubeLinesContainer]-[bottomGuide]"
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

@end
