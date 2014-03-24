//
//  DetailsViewManager.h
//  How Is Underground
//
//  Created by Hooman Ostovari on 24/03/2014.
//  Copyright (c) 2014 Hooman Ostovari. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailsViewManager : NSObject <UISplitViewControllerDelegate>

@property (weak,nonatomic) UISplitViewController *splitViewController;
@property (weak,nonatomic) UIViewController *currentLineStatusController;

+(DetailsViewManager *) sharedDetailsViewManager;

-(void)hidePopover;
-(void)setCurrentLineStatusController:(UIViewController *)lineStatusController :(BOOL)hidePopover;

@end
