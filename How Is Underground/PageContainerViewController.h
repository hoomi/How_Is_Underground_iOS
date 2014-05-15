//
//  ViewController.h
//  PageViewDemo
//
//  Created by Simon on 24/11/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@class LineStatusViewController;
@class LineStatus;
@interface PageContainerViewController : BaseViewController <UIPageViewControllerDataSource,UIPageViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIPageViewController *pageViewController;
@property NSInteger selectedIndex;
@property (copy,nonatomic) LineStatusViewController* (^initControllerAt)(NSInteger index);
@property (copy,nonatomic) LineStatus* (^getLineStatusAt)(NSInteger index);
@property (copy,nonatomic) NSInteger (^totalNumberOfLines)(void);
@property (copy,nonatomic) void (^setSelectedRow)(NSInteger index);


- (void) refresh;
@end
