//
//  ConnectivityUtils.h
//  How Is Underground
//
//  Created by Hooman Ostovari on 07/04/2014.
//  Copyright (c) 2014 Hooman Ostovari. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>

@interface ConnectivityUtils : NSObject

+(BOOL)isConnectedToWifi;
+(BOOL)isConnectedtoMobileNetworks;
+(BOOL)hasInternetConnection;

@end
