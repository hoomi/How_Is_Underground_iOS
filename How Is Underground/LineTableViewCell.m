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
{
    UIColor* lineColor;
    UIColor* textColor;
}

#pragma mark - LineTableViewCell functions

- (void)awakeFromNib
{
    self.lineStatusView.layer.cornerRadius = 9;
    self.borderView.layer.cornerRadius = 12;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (selected) {
        [self setBackgroundColor:[UIColor colorWithRed:200.0f/255.0f green:100.0f/255.0f blue:200.0f/255.0f alpha:1.0f]];
        [self.lineNameLabel setTextColor:[UIColor blackColor]];
    } else {
        [self setBackgroundColor:lineColor];
        [self.lineNameLabel setTextColor:textColor];
    }
}

- (void)setLineName:(NSString *)lineName :(NSInteger)lineId
{
    self.lineNameLabel.text = lineName;
    switch (lineId) {
        case BAKERLOO:
            lineColor = [UIColor bakerlooColor];
            textColor = [UIColor whiteTextLineColor];
            break;
        case CENTRAL:
            lineColor = [UIColor centralColor];
            textColor = [UIColor whiteTextLineColor];
            break;
        case CIRCLE:
            lineColor = [UIColor circleColor];
            textColor = [UIColor blueTextLineColor];
            break;
        case DISTRICT:
            lineColor = [UIColor districtColor];
            textColor = [UIColor whiteTextLineColor];
            break;
        case DLR:
            lineColor = [UIColor dlrColor];
            textColor = [UIColor whiteTextLineColor];
            break;
        case HANDCITY:
            lineColor = [UIColor handcColor];
            textColor = [UIColor blueTextLineColor];
            break;
        case JUBILEE:
            lineColor = [UIColor jubileeColor];
            textColor = [UIColor whiteTextLineColor];
            break;
        case METROPOLITAN:
            lineColor = [UIColor metropolitanColor];
            textColor = [UIColor whiteTextLineColor];
            break;
        case NORTHERN:
            lineColor = [UIColor northernColor];
            textColor = [UIColor whiteTextLineColor];
            break;
        case OVERGROUND:
            lineColor = [UIColor overgroundColor];
            textColor = [UIColor whiteTextLineColor];
            break;
        case PICCDILY:
            lineColor = [UIColor piccadilyColor];
            textColor = [UIColor whiteTextLineColor];
            break;
        case VICTORIA:
            lineColor = [UIColor victoriaColor];
            textColor = [UIColor whiteTextLineColor];
            break;
        default:
            lineColor = [UIColor waterlooColor];
            textColor = [UIColor blueColor];
            break;
    }
    
    [self.lineNameLabel setTextColor:textColor];
    [self setBackgroundColor: lineColor];
}

-(void)setLineStatus:(NSString *)lineStatus
{
    UIColor* color;
    if ([@"Good Service" isEqualToString:lineStatus]) {
        color = [UIColor goodService];
    } else if([@"Minor Delays" isEqualToString:lineStatus] ||
              [@"Bus Service" isEqualToString:lineStatus] ||
              [@"Reduced Service" isEqualToString:lineStatus]){
        color = [UIColor minorDelays];
    } else {
        color = [UIColor severDelays];
    }
    self.lineStatusView.backgroundColor = color;
}

- (NSString *)reuseIdentifier
{
    return @"LineCell";
}   

@end
