//
//  LineTableViewCell.m
//  How Is Underground
//
//  Created by Hooman Ostovari on 17/03/2014.
//  Copyright (c) 2014 Hooman Ostovari. All rights reserved.
//

#import "LineTableViewCell.h"
#import "UIColor+UIColorExtension.h"

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

- (void)setLineName:(NSString *)lineName :(NSInteger)lineId
{
    self.lineNameLabel.text = lineName;
    UIColor *backgroundColor = nil;
    UIColor *textColor = nil;
    switch (lineId) {
        case BAKERLOO:
            backgroundColor = [UIColor bakerlooColor];
            textColor = [UIColor whiteTextLineColor];
            break;
        case CENTRAL:
            backgroundColor = [UIColor centralColor];
            textColor = [UIColor whiteTextLineColor];
            break;
        case CIRCLE:
            backgroundColor = [UIColor circleColor];
            textColor = [UIColor blueTextLineColor];
            break;
        case DISTRICT:
            backgroundColor = [UIColor districtColor];
            textColor = [UIColor whiteTextLineColor];
            break;
        case DLR:
            backgroundColor = [UIColor dlrColor];
            textColor = [UIColor whiteTextLineColor];
            break;
        case HANDCITY:
            backgroundColor = [UIColor handcColor];
            textColor = [UIColor blueTextLineColor];
            break;
        case JUBILEE:
            backgroundColor = [UIColor jubileeColor];
            textColor = [UIColor whiteTextLineColor];
            break;
        case METROPOLITAN:
            backgroundColor = [UIColor metropolitanColor];
            textColor = [UIColor whiteTextLineColor];
            break;
        case NORTHERN:
            backgroundColor = [UIColor northernColor];
            textColor = [UIColor whiteTextLineColor];
            break;
        case OVERGROUND:
            backgroundColor = [UIColor overgroundColor];
            textColor = [UIColor whiteTextLineColor];
            break;
        case PICCDILY:
            backgroundColor = [UIColor piccadilyColor];
            textColor = [UIColor whiteTextLineColor];
            break;
        case VICTORIA:
            backgroundColor = [UIColor victoriaColor];
            textColor = [UIColor whiteTextLineColor];
            break;
        default:
            backgroundColor = [UIColor waterlooColor];
            textColor = [UIColor blueColor];
            break;
    }
    
    [self.lineNameLabel setTextColor:textColor];
    [self setBackgroundColor: backgroundColor];
}
- (NSString *)reuseIdentifier
{
    return @"LineCell";
}

@end
