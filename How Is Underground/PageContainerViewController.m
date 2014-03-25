//
//  ViewController.m
//  PageViewDemo
//
//  Created by Simon on 24/11/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "PageContainerViewController.h"
#import "LineStatusViewController.h"

@interface PageContainerViewController ()

@end

@implementation PageContainerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Mainstoryboard_iPhone" bundle:nil];
    self.pageViewController = [storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    LineStatusViewController *temp = self.getControllerAt(self.selectedIndex);
    [self.pageViewController setViewControllers:@[temp] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 30);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    self.pageViewController.delegate = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    LineStatusViewController* controller = (LineStatusViewController*) viewController;
    NSInteger index = controller.index;
    return self.getControllerAt(index - 1);
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    LineStatusViewController* controller = (LineStatusViewController*) viewController;
    NSInteger index = controller.index;
    return self.getControllerAt(index + 1);
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return self.totalNumberOfLines();
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return self.selectedIndex;
}

#pragma mark - Utility functions
-(void)refresh
{
    [self.pageViewController setViewControllers:@[self.getControllerAt(self.selectedIndex)] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];

}


@end
