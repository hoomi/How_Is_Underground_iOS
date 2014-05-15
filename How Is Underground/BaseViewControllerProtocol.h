//
//  BaseViewControllerProtocol.h
//  How Is Underground
//
//  Created by Hooman Ostovari on 07/04/2014.
//  Copyright (c) 2014 Hooman Ostovari. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BaseViewControllerProtocol <NSObject>

-(void)showConnectivityAlert;
-(void)showLoadingView;
-(void)dismissLoadingView;
-(void)showMap;

@optional
-(void)showMapButton;
-(void)hideMapButton;


@end
