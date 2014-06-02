//
//  BaseViewController.m
//  How Is Underground
//
//  Created by Hooman Ostovari on 07/04/2014.
//  Copyright (c) 2014 Hooman Ostovari. All rights reserved.
//

#import "BaseViewController.h"
#import "AlertViewHelper.h"
#import "JourneyPlannerViewController.h"

@interface BaseViewController ()

-(void)showJourneyPlannerButton;

@end

@implementation BaseViewController {
        UIBarButtonItem *mapButton;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - ADBannerViewDelegate

-(void)bannerViewDidLoadAd:(ADBannerView *)banner {
    
    [UIView beginAnimations:nil context:NULL];
    
    [UIView setAnimationDuration:1];
    
    [banner setAlpha:1];
    
    [UIView commitAnimations];
    
}



- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error

{
    
    [UIView beginAnimations:nil context:NULL];
    
    [UIView setAnimationDuration:1];
    
    [banner setAlpha:0];
    
    [UIView commitAnimations];
    
}

#pragma mark - BaseViewControllerProtocol functions

-(void)showLoadingView
{
    [[AlertViewHelper getInstance] showLoadingView];
}

-(void)showConnectivityAlert
{
    [[AlertViewHelper getInstance] showConnectivityAlert];
}

-(void)dismissLoadingView
{
    [[AlertViewHelper getInstance] dismissLoadingView];
}

-(void)showMap
{
    JourneyPlannerViewController* journeyPlannerViewController = [[JourneyPlannerViewController alloc] initWithNibName:@"JourneyPlannerViewController" bundle:[NSBundle mainBundle]];
    [journeyPlannerViewController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self.navigationController presentViewController:journeyPlannerViewController animated:YES completion:nil];
}

#pragma mark - Utility Functions

-(void)showJourneyPlannerButton
{
    if (mapButton == nil) {
        mapButton = [[UIBarButtonItem alloc]
                     initWithTitle:@"Joruney Planner"
                     style:UIBarButtonItemStyleBordered
                     target:self
                     action:@selector(showMap)];
    }
    self.navigationItem.rightBarButtonItem = mapButton;
}

-(void)hideJourneyPlannerButton
{
    self.navigationItem.rightBarButtonItem =  nil;
}


@end
