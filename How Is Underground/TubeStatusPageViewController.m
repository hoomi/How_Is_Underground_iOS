//
//  TubeStatusPageViewController.m
//  How Is Underground
//
//  Created by Hooman Ostovari on 18/03/2014.
//  Copyright (c) 2014 Hooman Ostovari. All rights reserved.
//

#import "TubeStatusPageViewController.h"
#import "LineStatusViewController.h"

@interface TubeStatusPageViewController ()

@end

@implementation TubeStatusPageViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    if (self.nextCarBlock) {
        return self.nextCarBlock();
    }
    return nil;
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    if (self.prevCarBlock) {
        return self.prevCarBlock();
    }
    return nil;
}

-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    if (self.totalNumberOfLines) {
        return self.totalNumberOfLines();
    }
    return 0;
}

@end
