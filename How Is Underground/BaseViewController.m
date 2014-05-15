//
//  BaseViewController.m
//  How Is Underground
//
//  Created by Hooman Ostovari on 07/04/2014.
//  Copyright (c) 2014 Hooman Ostovari. All rights reserved.
//

#import "BaseViewController.h"
#import "AlertViewHelper.h"
#import "TubeMapViewController.h"

@interface BaseViewController ()

-(void)showMapButton;

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



- (void)bannerView:(ADBannerView *)

banner didFailToReceiveAdWithError:(NSError *)error

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
    TubeMapViewController* tubeMapViewController = [[TubeMapViewController alloc] initWithNibName:@"TubeMapViewController" bundle:[NSBundle mainBundle]];
    [tubeMapViewController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self.navigationController presentViewController:tubeMapViewController animated:YES completion:nil];
}

#pragma mark - Utility Functions

-(void)showMapButton
{
    if (mapButton == nil) {
        mapButton = [[UIBarButtonItem alloc]
                     initWithTitle:@"Map"
                     style:UIBarButtonItemStyleBordered
                     target:self
                     action:@selector(showMap)];
    }
    self.navigationItem.rightBarButtonItem = mapButton;
}

-(void)hideMapButton
{
    self.navigationItem.rightBarButtonItem =  nil;
}


@end
