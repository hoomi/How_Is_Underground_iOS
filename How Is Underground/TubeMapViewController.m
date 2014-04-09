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
    
}

- (void) setupScrollContent
{
    
    self.scrollView.contentSize = self.tubeMapImage.bounds.size;
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

    self.scrollView.minimumZoomScale= 0.3
    ;
    self.scrollView.zoomScale = self.view.bounds.size.width / self.tubeMapImage.bounds.size.width;
    self.scrollView.maximumZoomScale=6.0;
    self.scrollView.contentSize=self.view.bounds.size;
    self.scrollView.delegate=self;
    if (!IsIpad()) {
        myNavigationItem.leftBarButtonItem = backButton;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
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


#pragma UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.tubeMapImage;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view layoutIfNeeded];
}
- (IBAction)resetZoom:(id)sender {
    
}
- (IBAction)backPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
