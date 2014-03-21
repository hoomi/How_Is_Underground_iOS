//
//  LineTableViewCell.h
//  How Is Underground
//
//  Created by Hooman Ostovari on 17/03/2014.
//  Copyright (c) 2014 Hooman Ostovari. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"

@interface LineTableViewCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lineNameLabel;
@property (weak, nonatomic) IBOutlet UIView *lineStatusView;
@property (weak, nonatomic) IBOutlet UIView *borderView;

-(void)setLineName:(NSString*) lineName :(NSInteger) lineId;
-(void)setLineStatus:(NSString*) lineStatus;

@end
