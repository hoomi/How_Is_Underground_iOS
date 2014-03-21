//
//  LineTableViewCell.m
//  How Is Underground
//
//  Created by Hooman Ostovari on 17/03/2014.
//  Copyright (c) 2014 Hooman Ostovari. All rights reserved.
//

#import "LineTableViewCell.h"
#import "UIColor+UIColorExtension.h"

#define GOOD_SERVICE 0
#define MINOR_DELAYS 1
#define SEVERE_DELAYS 2
#define ANIMATION_DURATION 5.0

@implementation LineTableViewCell

static NSMutableArray* sadImages;
static NSMutableArray* verySadImages;
static NSMutableArray* happyImages;
static CATransition* transition;


#pragma mark - Static Functions

+ (NSArray *)sadArrayOfImages
{
    if (sadImages ==  nil) {
        sadImages = [NSMutableArray new];
        NSArray *tempSadImages = @[@"normalface.png",@"sadface.png"];
        for (NSString* s in tempSadImages) {
            [sadImages addObject:[UIImage imageNamed:s]];
        }
    }
    return sadImages;
}

+ (NSArray *)happyArrayOfImage
{
    if (happyImages == nil) {
        happyImages = [NSMutableArray new];
        NSArray *tempHappyImages = @[@"normalface.png",@"smileyface.png",@"smileyface2.png"];
        for (NSString* s in tempHappyImages) {
            [happyImages addObject:[UIImage imageNamed:s]];
        }
    }
    return happyImages;
}

+ (NSArray *)verySadArrayOfImage
{
    if (verySadImages == nil) {
        verySadImages = [NSMutableArray new];
        NSArray *tempVerySadImages = @[@"normalface.png",@"sadface.png",@"sadface2.png"];
        for (NSString* s in tempVerySadImages) {
            [verySadImages addObject:[UIImage imageNamed:s]];
        }
    }
    return verySadImages;
}

+(CATransition*) transitionBetweenImages
{
    if (transition == nil) {
        transition = [CATransition animation];
        transition.duration = 2.0f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionFade;
    }
    return transition;
}
#pragma mark - LineTableViewCell functions

- (void)awakeFromNib
{
    [self.lineStatusImageView.layer addAnimation:[LineTableViewCell transitionBetweenImages] forKey:nil];
    self.lineStatusImageView.animationDuration = ANIMATION_DURATION;
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

-(void)setLineStatus:(NSString *)lineStatus
{
    NSInteger animationType = GOOD_SERVICE;
    if ([@"Good Service" isEqualToString:lineStatus]) {
        animationType = GOOD_SERVICE;
    } else if([@"Minor Delays" isEqualToString:lineStatus] ||
              [@"Bus Service" isEqualToString:lineStatus] ||
              [@"Reduced Service" isEqualToString:lineStatus]){
        animationType = MINOR_DELAYS;
    } else {
        animationType = SEVERE_DELAYS;
    }
    [self setAnimation:animationType];
}

-(void) setAnimation:(NSInteger) animationType
{
    [self.lineStatusImageView stopAnimating];
    NSArray *images;
    switch (animationType) {
        case GOOD_SERVICE:
            images = [LineTableViewCell happyArrayOfImage];
            break;
        case MINOR_DELAYS:
            images = [LineTableViewCell sadArrayOfImages];
            break;
        case SEVERE_DELAYS:
            images = [LineTableViewCell verySadArrayOfImage];
            break;
        default:
            images = @[@"normalface.png"];
            break;
    }
    self.lineStatusImageView.animationImages = images;
    [self.lineStatusImageView startAnimating];
}
- (NSString *)reuseIdentifier
{
    return @"LineCell";
}

@end
