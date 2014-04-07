//
//  UndergroundLinesTableViewController.h
//  How Is Underground
//
//  Created by Hooman Ostovari on 17/03/2014.
//  Copyright (c) 2014 Hooman Ostovari. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "BaseTableViewController.h"
#import "PageContainerViewController.h"

//@class PageContainerViewController;

@interface UndergroundLinesTableViewController :  BaseTableViewController <UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate>

@end
