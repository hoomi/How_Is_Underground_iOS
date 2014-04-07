//
//  LineStatusViewController.h
//  How Is Underground
//
//  Created by Hooman Ostovari on 18/03/2014.
//  Copyright (c) 2014 Hooman Ostovari. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineStatus.h"
#import "BaseViewController.h"

@interface LineStatusViewController : BaseViewController
@property NSInteger index;
@property (strong, nonatomic) LineStatus *lineStatus;
@property (weak, nonatomic) IBOutlet UILabel *lineNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lineStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *lineDescriptionsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;

-(void) updateUi;
@end
