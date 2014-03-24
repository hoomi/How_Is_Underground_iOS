//
//  DetailsViewManager.m
//  How Is Underground
//
//  Created by Hooman Ostovari on 24/03/2014.
//  Copyright (c) 2014 Hooman Ostovari. All rights reserved.
//

#import "DetailsViewManager.h"

@implementation DetailsViewManager
{
    UINavigationController *detailsNavigationController;
    UIBarButtonItem *menuPopoverButtonItem;
    UIPopoverController *menuPopoverController;
    
}

+(DetailsViewManager *)sharedDetailsViewManager
{
    static DetailsViewManager *sharedDetailsViewManager;
    static dispatch_once_t pred;
    
    dispatch_once(&pred,^{
        sharedDetailsViewManager = [super new];
    });
    return sharedDetailsViewManager;
}

#pragma mark - UISplitViewControllerDelegate

-(BOOL)splitViewController:(UISplitViewController *)svc
  shouldHideViewController:(UIViewController *)vc
             inOrientation:(UIInterfaceOrientation)orientation
{
    return UIInterfaceOrientationIsPortrait(orientation);
}

-(void)splitViewController:(UISplitViewController *)svc
    willHideViewController:(UIViewController *)aViewController
         withBarButtonItem:(UIBarButtonItem *)barButtonItem
      forPopoverController:(UIPopoverController *)pc
{
    
    barButtonItem.title = @"Menu";                                          // 2
    
    menuPopoverButtonItem = barButtonItem;                                  // 3
    menuPopoverController = pc;
    
    UINavigationItem *detailNavItem =                                       // 4
    detailsNavigationController.topViewController.navigationItem;
    detailNavItem.leftBarButtonItem = barButtonItem;
}

- (void)splitViewController:(UISplitViewController *)svc                    // 5
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    menuPopoverButtonItem = nil;                                            // 6
    menuPopoverController = nil;
    
    UINavigationItem *detailNavItem =                                       // 7
    detailsNavigationController.topViewController.navigationItem;
    detailNavItem.leftBarButtonItem = nil;
    
}

#pragma mark - public functions

- (void)setSplitViewController:(UISplitViewController *)splitViewController {
    if (splitViewController != _splitViewController) {                      // 1
        _splitViewController = splitViewController;                         // 2
        detailsNavigationController =                                               // 3
        [splitViewController.viewControllers lastObject];
        _splitViewController.delegate = self;                               // 4
    }
}

-(void)setCurrentLineStatusController:(UIViewController *)currentLineStatusController
{
    [self setCurrentLineStatusController:currentLineStatusController :false];
}

-(void)setCurrentLineStatusController:(UIViewController *)lineStatusController :(BOOL)hidePopover
{
    
    NSArray *newStack = nil;                                                 // 1
    if (lineStatusController == nil) {                                       // 2
        UINavigationController *rootController =                             // 3
        detailsNavigationController.viewControllers[0];
        
        if (detailsNavigationController.topViewController != rootController) {       // 4
            
            newStack = @[detailsNavigationController.viewControllers[0]];            // 5
            
        }
    } else if (![lineStatusController isMemberOfClass:                       // 6
                 [detailsNavigationController.topViewController class]]) {
        
        newStack = @[detailsNavigationController.viewControllers[0],                 // 7
                     lineStatusController];
    }
    
    if (hidePopover) {
        [self hidePopover];                                                  // 8
    }
    
    if (newStack != nil) {
        CATransition *transition = [CATransition animation];
        transition.duration = 0.7f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionReveal;
        transition.subtype = kCATransitionFromRight;
        [detailsNavigationController.view.layer addAnimation:transition forKey:nil];
        [detailsNavigationController setViewControllers:newStack animated:NO];      // 9
        
        _currentLineStatusController = detailsNavigationController.topViewController;      // 10
        _currentLineStatusController.navigationItem.leftBarButtonItem = menuPopoverButtonItem;
    }

}

-(void)hidePopover
{
    [menuPopoverController dismissPopoverAnimated:YES];

}


@end
