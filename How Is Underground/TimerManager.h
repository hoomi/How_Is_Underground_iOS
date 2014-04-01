//
//  TimerManager.h
//  How Is Underground
//
//  Created by Hooman Ostovari on 01/04/2014.
//  Copyright (c) 2014 Hooman Ostovari. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimerManager : NSObject

+(TimerManager*)getInstance;

-(void)scheduledTimerWithTimeInterval:(NSTimeInterval)seconds invocation:(NSInvocation *)invocation repeats:(BOOL)repeats id:(NSInteger) id;
- (void) destroyAll;
- (void)destroyTimer:(NSInteger)id;

@end
