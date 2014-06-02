//
//  JourneyPlannerViewController.m
//  How Is Underground
//
//  Created by Hooman Ostovari on 02/06/2014.
//  Copyright (c) 2014 Hooman Ostovari. All rights reserved.
//

#import "JourneyPlannerViewController.h"

@interface JourneyPlannerViewController ()

@end

@implementation JourneyPlannerViewController
{
    __weak IBOutlet UIBarButtonItem *backButton;
    __weak IBOutlet UINavigationItem *myNavigationItem;
    __weak IBOutlet ADBannerView *adBannerView;
    __weak IBOutlet NSLayoutConstraint *navigationBarHeight;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!IsIpad()) {
        myNavigationItem.leftBarButtonItem = backButton;
        navigationBarHeight.constant = 64;
    }
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"journeyplanner" ofType:@"html"]isDirectory:NO]]];
    adBannerView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - ADBannerViewDelegate
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    [NSLogger log:[NSString stringWithFormat:@"didFailToReceiveAdWithError: error %@ %@",error,[error userInfo]]];
}

- (void) bannerViewDidLoadAd:(ADBannerView *)banner
{
    [NSLogger log:(@"bannerViewDidLoadAd")];
    
}

#pragma mark - IBActions

- (IBAction)backPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
