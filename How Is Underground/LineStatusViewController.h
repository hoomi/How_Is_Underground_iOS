//
//  LineStatusViewController.h
//  How Is Underground
//
//  Created by Hooman Ostovari on 18/03/2014.
//  Copyright (c) 2014 Hooman Ostovari. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LineStatusViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lineNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lineStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *lineDescriptions;

@end
