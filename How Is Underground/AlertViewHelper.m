//
//  AlertViewHelper.m
//  How Is Underground
//
//  Created by Hooman Ostovari on 07/04/2014.
//  Copyright (c) 2014 Hooman Ostovari. All rights reserved.
//

#import "AlertViewHelper.h"

static UIAlertView* connectivityAlertView;
static UIAlertView* loadingView;


@implementation AlertViewHelper


+(AlertViewHelper*)getInstance
{
    static AlertViewHelper *singleInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleInstance=[[AlertViewHelper alloc]init];
    });
    return singleInstance;
}

#pragma mark - UIAlertViewDelegate funtions

-(void)alertViewCancel:(UIAlertView *)alertView
{
    
}

#pragma mark - Common functions
-(void)showConnectivityAlert
{
    if (!connectivityAlertView) {
        connectivityAlertView = [[UIAlertView alloc]
                                 initWithTitle:NSLocalizedStringWithDefaultValue(@"ConnectionErrorTitle", @"Connection", [NSBundle mainBundle], @"Connection Error", @"Coonection error title")
                                 message:NSLocalizedStringWithDefaultValue(@"ConnectionErrorMessage", @"Connection", [NSBundle mainBundle], @"The application requires activie internet connection.The data that you see may not be updated", @"Message to be shown when application does not have active connection")
                                 delegate:self cancelButtonTitle:NSLocalizedStringWithDefaultValue(@"ok", @"General", [NSBundle mainBundle], @"OK", @"ok String") otherButtonTitles:nil, nil];
                [connectivityAlertView show];
    }
    if (!connectivityAlertView.visible) {
        [connectivityAlertView show];
    }
}

-(void) showLoadingView
{
    if (loadingView == nil) {
        loadingView = [[UIAlertView alloc] initWithTitle:@"Loading..." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        [loadingView show];
    }
    else if (!loadingView.visible) {
        [loadingView show];
    }
}

- (void) dismissLoadingView
{
    if (loadingView == nil) {
        return;
    }
    [loadingView dismissWithClickedButtonIndex:0 animated:YES];
    
}



@end
