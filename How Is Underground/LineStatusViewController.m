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
    NSArray *landscapeConstraints;
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
    [self setLayoutConstraints:[[UIApplication sharedApplication] statusBarOrientation]];
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

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self setLayoutConstraints:[[UIApplication sharedApplication] statusBarOrientation]];
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    self.scrollView.contentSize = self.contentView.bounds.size;
}

#pragma mark - Utility functions

-(void) setLayoutConstraints:(UIInterfaceOrientation)orientation
{
    [self initLayoutConstraints];
    if (IsIpad()) {
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            [self.contentView removeConstraints:landscapeConstraints];
            [self.contentView addConstraints:portraitConstraints];
        } else {
            [self.contentView removeConstraints:portraitConstraints];
            [self.contentView addConstraints:landscapeConstraints];
        }
        
        return;
    }
    if (UIInterfaceOrientationIsLandscape([[UIDevice currentDevice]orientation])) {
        [self.contentView removeConstraints:portraitConstraints];
        [self.contentView addConstraints:landscapeConstraints];
    } else {
        [self.contentView removeConstraints:landscapeConstraints];
        [self.contentView addConstraints:portraitConstraints];
    }
    
}

-(void) initLayoutConstraints
{
    if (landscapeConstraints == nil) {
        id statusImageView = self.statusImageView;
        
        NSMutableArray *tempRootLayoutConstraints;
        NSArray *generatedLayoutConstraints;
        NSDictionary *views = NSDictionaryOfVariableBindings(statusImageView,textWrapperView);
        tempRootLayoutConstraints = [NSMutableArray new];
        generatedLayoutConstraints = [NSLayoutConstraint
                                      constraintsWithVisualFormat:@"H:|-[textWrapperView]-20-[statusImageView]-|" options:0 metrics:nil views:views];
        [tempRootLayoutConstraints addObjectsFromArray:generatedLayoutConstraints];
        generatedLayoutConstraints = [NSLayoutConstraint
                                      constraintsWithVisualFormat:@"V:|-[textWrapperView]-|" options:0 metrics:nil views:views];
        [tempRootLayoutConstraints addObjectsFromArray:generatedLayoutConstraints];
        NSLayoutConstraint *yCenterConstraint = [NSLayoutConstraint constraintWithItem:statusImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
        [tempRootLayoutConstraints addObject:yCenterConstraint];
        landscapeConstraints = [NSArray arrayWithArray:tempRootLayoutConstraints];
    }
}
-(void)updateUi
{
    animationType = SEVERE_DELAYS;
    if (self.lineStatus != nil) {
        if ([self.lineStatus.status.descriptions isEqualToString:GOOD_SERVICE_STRING]) {
            animationType = GOOD_SERVICE;
        } else if ([self.lineStatus.status.descriptions isEqualToString:MINOR_DELAYS_STRING]) {
            
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
