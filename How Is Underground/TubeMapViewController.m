//
//  TubeMapViewController.m
//  How Is Underground
//
//  Created by Hooman Ostovari on 07/04/2014.
//  Copyright (c) 2014 Hooman Ostovari. All rights reserved.
//

#import "TubeMapViewController.h"

@implementation TubeMapViewController
{
    __weak IBOutlet UINavigationItem *myNavigationItem;
    __weak IBOutlet UIBarButtonItem *backButton;
    
    __weak IBOutlet UIBarButtonItem *resetZoomButton;
    __weak IBOutlet NSLayoutConstraint *navigationBarHeight;
}

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
    [self setupScrollContent];
    [self.view layoutIfNeeded];
    self.scrollView.minimumZoomScale= 0.2;
    self.scrollView.maximumZoomScale=6.0;
    self.scrollView.delegate=self;
    if (!IsIpad()) {
        myNavigationItem.leftBarButtonItem = backButton;
        navigationBarHeight.constant = 64   ;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setZoomScale];
    [self validateResetButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self setupScrollContent];
    self.navigationController.navigationBarHidden = UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
}
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self setZoomScale];
}


#pragma UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.tubeMapImage;
}
-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    [self validateResetButton];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view layoutIfNeeded];
}
- (IBAction)resetZoom:(id)sender {
    [self setZoomScale];
    resetZoomButton.enabled = NO;

#pragma mark - IBActions
}
- (IBAction)backPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Utility functions

- (void) setupScrollContent
{
    
    self.scrollView.contentSize = self.tubeMapImage.bounds.size;
}

-(void)validateResetButton
{
    CGFloat scale = MAX(self.view.bounds.size.width / self.tubeMapImage.bounds.size.width, 0.2);
    if (self.scrollView.zoomScale > scale) {
        resetZoomButton.enabled = YES;
    } else {
        resetZoomButton.enabled = NO;
    }
}

-(void)setZoomScale
{
    self.scrollView.contentSize = self.tubeMapImage.bounds.size;
    CGFloat scale = MAX(self.view.bounds.size.width / self.tubeMapImage.bounds.size.width, 0.2);
    [self.scrollView setZoomScale:scale animated:YES];
    [NSLogger log:[NSString stringWithFormat:@"%f",scale]];

    
}

@end
