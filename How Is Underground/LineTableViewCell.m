//
//  LineTableViewCell.m
//  How Is Underground
//
//  Created by Hooman Ostovari on 17/03/2014.
//  Copyright (c) 2014 Hooman Ostovari. All rights reserved.
//

#import "LineTableViewCell.h"

@implementation LineTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setLineName:(NSString *)lineNameLabel
{
    self.lineNameLabel.text = lineNameLabel;
}
- (NSString *)reuseIdentifier
{
    return @"LineCell";
}

@end
