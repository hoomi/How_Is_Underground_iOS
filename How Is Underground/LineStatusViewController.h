//
//  LineStatusViewController.h
//  How Is Underground
//
//  Created by Hooman Ostovari on 18/03/2014.
//  Copyright (c) 2014 Hooman Ostovari. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineStatus.h"

@interface LineStatusViewController : UIViewController
@property NSInteger index;
@property (strong, nonatomic) LineStatus *lineStatus;
@property (weak, nonatomic) IBOutlet UILabel *lineNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lineStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *lineDescriptionsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;

-(void) updateUi;
@end
