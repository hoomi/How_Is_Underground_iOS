//
//  TubeStatusPageViewController.h
//  How Is Underground
//
//  Created by Hooman Ostovari on 18/03/2014.
//  Copyright (c) 2014 Hooman Ostovari. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LineStatusViewController;

@interface TubeStatusPageViewController : UIPageViewController<UIPageViewControllerDataSource>

@property NSInteger currentPage;
@property (copy,nonatomic) LineStatusViewController* (^nextCarBlock)(void);
@property (copy,nonatomic) LineStatusViewController* (^prevCarBlock)(void);
@property (copy,nonatomic) NSInteger (^totalNumberOfLines)(void);


@end
