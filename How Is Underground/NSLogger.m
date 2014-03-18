//
//  NSLogger.m
//  How Is Underground
//
//  Created by Hooman Ostovari on 18/03/2014.
//  Copyright (c) 2014 Hooman Ostovari. All rights reserved.
//

#import "NSLogger.h"

#if DEBUG==1

#define SHOW_LOGS YES

#endif

#if RELEASE==1

#define SHOW_LOGS NO

#endif

@implementation NSLogger

+ (void)log:(NSString*) message
{
    if (SHOW_LOGS) {
        NSLog(@"%@",message);
    }
}

@end
