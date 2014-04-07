//
//  BaseViewController.m
//  How Is Underground
//
//  Created by Hooman Ostovari on 07/04/2014.
//  Copyright (c) 2014 Hooman Ostovari. All rights reserved.
//

#import "BaseViewController.h"
#import "AlertViewHelper.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

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
    // Do any additional setup after loading the view.
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

@end
