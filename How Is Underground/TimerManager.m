//
//  TimerManager.m
//  How Is Underground
//
//  Created by Hooman Ostovari on 01/04/2014.
//  Copyright (c) 2014 Hooman Ostovari. All rights reserved.
//

#import "TimerManager.h"

#define MAXIMUM_TIMER_CAPACITY 10
#define TIMER_TOLERANCE 60.0

@implementation TimerManager {
    NSMutableDictionary *dictionaryOfTimers;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        dictionaryOfTimers = [[NSMutableDictionary alloc] initWithCapacity:MAXIMUM_TIMER_CAPACITY];
    }
    return self;
}

+(TimerManager *)getInstance
{
    static TimerManager *sharedTimeManager;
    static dispatch_once_t pred;
    
    dispatch_once(&pred,^{
        sharedTimeManager = [[TimerManager alloc] init];
    });
    return sharedTimeManager;

    
}

-(void)scheduledTimerWithTimeInterval:(NSTimeInterval)seconds invocation:(NSInvocation *)invocation repeats:(BOOL)repeats id:(NSInteger)id
{
        NSString* stringId = [NSString stringWithFormat:@"%ld",id];
    if (dictionaryOfTimers != nil && [dictionaryOfTimers count] < 10 && [dictionaryOfTimers objectForKey:stringId] == nil) {
        NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:seconds invocation:invocation repeats:repeats];
        [timer setTolerance:TIMER_TOLERANCE];
        [dictionaryOfTimers setObject: timer forKey:stringId];
    } else if ( [dictionaryOfTimers count] >= 10 ){
        NSLog(@"TimerManager reached its peak. Release some Timers before adding a new one");
    } else if (dictionaryOfTimers == nil) {
        NSLog(@"TimerManager has not been initialized properly");
    } else {
        NSLog(@"The timer with current id exists already");
    }
}

- (void)destroyTimer:(NSInteger)id
{
    NSString* stringId = [NSString stringWithFormat:@"%ld",id];
    if (dictionaryOfTimers != nil) {
        NSTimer *timer = [dictionaryOfTimers objectForKey:stringId];
        if (timer != nil){
            [timer invalidate];
            [dictionaryOfTimers removeObjectForKey:stringId];
        }
    }
}

- (void) destroyAll
{
    for (NSTimer* timer in [dictionaryOfTimers allValues]) {
        if ([timer isValid]) {
            [timer invalidate];
        }
    }
    [dictionaryOfTimers removeAllObjects];
}

@end
