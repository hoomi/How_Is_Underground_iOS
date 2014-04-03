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

- (DetailsViewManager* ) init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    UIImage* image3 = [UIImage imageNamed:@"hamburger.png"];
       menuPopoverButtonItem =[[UIBarButtonItem alloc] initWithImage:image3 style:UIBarButtonItemStylePlain target:self action:@selector(togglePopOver)];
    return self;
}

+(DetailsViewManager *)sharedDetailsViewManager
{
    static DetailsViewManager *sharedDetailsViewManager;
    static dispatch_once_t pred;
    
    dispatch_once(&pred,^{
        sharedDetailsViewManager = [[DetailsViewManager alloc ]init];
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

#pragma mark - public functions

- (void)setSplitViewController:(UISplitViewController *)splitViewController {
    if (splitViewController != _splitViewController) {                      // 1
        _splitViewController = splitViewController;                         // 2
        detailsNavigationController =                                               // 3
        [splitViewController.viewControllers lastObject];
        _splitViewController.delegate = self;
//        [detailsNavigationController setNavigationBarHidden:YES animated:YES];// 4
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
        [self hidePopover];                                                  
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
- (void) togglePopOver
{
    if (menuPopoverController.popoverVisible) {
        [self hidePopover];
    }else {
        
        [menuPopoverController presentPopoverFromBarButtonItem:menuPopoverButtonItem permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    }
}

-(void)hidePopover
{
    [menuPopoverController dismissPopoverAnimated:YES];

}


@end
