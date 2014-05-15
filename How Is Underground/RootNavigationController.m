//
//  RootNavigationController.m
//  How Is Underground
//
//  Created by Hooman Ostovari on 15/05/2014.
//  Copyright (c) 2014 Hooman Ostovari. All rights reserved.
//

#import "RootNavigationController.h"
#import "UndergroundLineStatusViewController.h"
#import "TubeMapViewController.h"

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

-(void)showMap
{
    TubeMapViewController* tubeMapViewController = [[TubeMapViewController alloc] initWithNibName:@"TubeMapViewController" bundle:[NSBundle mainBundle]];
    [tubeMapViewController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self.navigationController presentViewController:tubeMapViewController animated:YES completion:nil];
}


@end
