//
//  RootNavigationController.m
//  How Is Underground
//
//  Created by Hooman Ostovari on 15/05/2014.
//  Copyright (c) 2014 Hooman Ostovari. All rights reserved.
//

#import "RootNavigationController.h"
#import "UndergroundLineStatusViewController.h"
#import "JourneyPlannerViewController.h"

@interface RootNavigationController ()

@end

@implementation RootNavigationController {
}

#pragma mark - Init functions

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

#pragma mark - Controller Callbacks

- (void)viewDidLoad
{
    [super viewDidLoad];
    UndergroundLineStatusViewController* undergroundLineStatusViewController = [[UndergroundLineStatusViewController alloc] initWithNibName:@"UndergroundLineStatusViewController" bundle:[NSBundle mainBundle]];
    [self pushViewController:undergroundLineStatusViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - User Interactions

-(void)showJourneyPlanner
{
    JourneyPlannerViewController* journeyPlannerViewController = [[JourneyPlannerViewController alloc] initWithNibName:@"JourneyPlannerViewController" bundle:[NSBundle mainBundle]];
    [journeyPlannerViewController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self.navigationController presentViewController:journeyPlannerViewController animated:YES completion:nil];
}


@end
