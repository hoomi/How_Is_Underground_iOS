//
//  UndergroundLineStatusViewController.h
//  How Is Underground
//
//  Created by Hooman Ostovari on 15/05/2014.
//  Copyright (c) 2014 Hooman Ostovari. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "BaseViewController.h"

@interface UndergroundLineStatusViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet ADBannerView *adBannerView;

@end
