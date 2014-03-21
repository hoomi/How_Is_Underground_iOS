//
//  LineStatusViewController.m
//  How Is Underground
//
//  Created by Hooman Ostovari on 18/03/2014.
//  Copyright (c) 2014 Hooman Ostovari. All rights reserved.
//

#import "LineStatusViewController.h"
#import "Line.h"
#import "Status.h"
#import "UIColor+UIColorExtension.h"


#define GOOD_SERVICE 0
#define MINOR_DELAYS 1
#define SEVERE_DELAYS 2
#define ANIMATION_DURATION 5.0

@interface LineStatusViewController ()

@end

@implementation LineStatusViewController

@synthesize lineNameLabel;

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
#pragma mark - LineStatusViewController functions
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateUi];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)updateUi
{
    if (self.lineStatus != nil) {
        lineNameLabel.text = self.lineStatus.line.name;
        self.lineDescriptionsLabel.text = self.lineStatus.status.descriptions;
        self.lineStatusLabel.text = IsEmptyString(self.lineStatus.statusDetails) ? self.lineStatus.status.descriptions: self.lineStatus.statusDetails;
        
        UIColor *backgroundColor = nil;
        UIColor *textColor = nil;
        switch ([self.lineStatus.line.id integerValue]) {
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
        [self.view setBackgroundColor:backgroundColor];
        [self.lineStatusLabel setTextColor:textColor];
        [self.lineDescriptionsLabel setTextColor:textColor];
        [self.lineNameLabel setTextColor:textColor];
 
    }
}

@end
