//
//  ViewController.h
//  PageViewDemo
//
//  Created by Simon on 24/11/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LineStatusViewController;
@interface PageContainerViewController : UIViewController <UIPageViewControllerDataSource,UIPageViewControllerDelegate>

@property NSInteger selectedIndex;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (copy,nonatomic) LineStatusViewController* (^getControllerAt)(NSInteger index);
@property (copy,nonatomic) NSInteger (^totalNumberOfLines)(void);
@property (copy,nonatomic) void (^setSelectedRow)(NSInteger index);


- (void) refresh;
@end
