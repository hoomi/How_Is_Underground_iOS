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
#define ANIMATION_DURATION 2.0

@interface LineStatusViewController ()

@end

@implementation LineStatusViewController
{
    NSInteger animationType;
    IBOutletCollection(NSLayoutConstraint)NSArray *portraitConstraints;
    IBOutletCollection(NSLayoutConstraint)NSArray *landscapeConstraints;
    __weak IBOutlet UIView *textWrapperView;
}

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
        NSArray *tempHappyImages = @[@"normalface.png",@"smileyface2.png",@"smileyface.png",@"smileyface2.png"];
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
        NSArray *tempVerySadImages = @[@"normalface.png",@"sadface.png",@"sadface2.png",@"sadface.png"];
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
    [self setAnimation];
    self.scrollView.contentSize = self.contentView.bounds.size;
    [self.scrollView addSubview:self.contentView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.statusImageView startAnimating];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.statusImageView stopAnimating];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
      [self setLayoutConstraints];
    self.scrollView.contentSize = self.contentView.bounds.size;
}

#pragma mark - Utility functions

- (void) removeSubViews
{
    for (UIView* subview in [self.scrollView subviews]) {
        [subview removeFromSuperview];
    }
}

-(void) setLayoutConstraints
{
    if (!IsIpad()) {
        [self initLayoutConstraints];
        if (UIInterfaceOrientationIsLandscape([[UIDevice currentDevice]orientation])) {
            [self.contentView removeConstraints:portraitConstraints];
            [self.contentView addConstraints:landscapeConstraints];
        } else {
            [self.contentView removeConstraints:landscapeConstraints];
            [self.contentView addConstraints:portraitConstraints];
        }
    }
    
}

-(void) initLayoutConstraints
{
    id topGuide = self.topLayoutGuide;
    id bottomGuide = self.bottomLayoutGuide;
    id contentView = self.contentView, statusImageView = self.statusImageView;
    
    NSMutableArray *tempRootLayoutConstraints;
    NSArray *generatedLayoutConstraints;
    if (landscapeConstraints == nil) {
        NSDictionary *views = NSDictionaryOfVariableBindings(contentView,topGuide,bottomGuide,statusImageView,textWrapperView);
        tempRootLayoutConstraints = [NSMutableArray new];
        generatedLayoutConstraints = [NSLayoutConstraint
                                      constraintsWithVisualFormat:@"H:|-[textWrapperView]-[statusImageView]-|" options:0 metrics:nil views:views];
        [tempRootLayoutConstraints addObjectsFromArray:generatedLayoutConstraints];
        generatedLayoutConstraints = [NSLayoutConstraint
                                      constraintsWithVisualFormat:@"V:|-[statusImageView]-|" options:0 metrics:nil views:views];
        [tempRootLayoutConstraints addObjectsFromArray:generatedLayoutConstraints];
        landscapeConstraints = [NSArray arrayWithArray:tempRootLayoutConstraints];
    }
}
-(void)updateUi
{
    animationType = SEVERE_DELAYS;
    if (self.lineStatus != nil) {
        if ([self.lineStatus.status.descriptions isEqualToString:@"Good Service"]) {
            animationType = GOOD_SERVICE;
        } else if ([self.lineStatus.status.descriptions isEqualToString:@"Minor Delays"]) {
            
        }
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

-(void)setAnimation
{
    
    [self.statusImageView stopAnimating];
    NSArray *images;
    switch (animationType) {
        case GOOD_SERVICE:
            images = [LineStatusViewController happyArrayOfImage];
            break;
        case MINOR_DELAYS:
            images = [LineStatusViewController sadArrayOfImages];
            break;
        case SEVERE_DELAYS:
            images = [LineStatusViewController verySadArrayOfImage];
            break;
        default:
            images = @[@"normalface.png"];
            break;
    }
    self.statusImageView.animationImages = images;
    self.statusImageView.animationDuration = ANIMATION_DURATION;
    [self.statusImageView startAnimating];
    
}

@end
