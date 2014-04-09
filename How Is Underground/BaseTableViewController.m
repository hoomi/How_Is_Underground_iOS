//
//  BaseTableViewController.m
//  How Is Underground
//
//  Created by Hooman Ostovari on 07/04/2014.
//  Copyright (c) 2014 Hooman Ostovari. All rights reserved.
//

#import "BaseTableViewController.h"
#import "AlertViewHelper.h"
#import "TubeMapViewController.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
