//
//  ServerCommunicator.m
//  How Is Underground
//
//  Created by Hooman Ostovari on 18/03/2014.
//  Copyright (c) 2014 Hooman Ostovari. All rights reserved.
//

#import "ServerCommunicator.h"

@implementation ServerCommunicator
{
    
}

- (void) requestLineStatus :(void (^)(NSURLResponse*, NSData*, NSError*)) completeBlock
{
    [self request:UNDERGROUND_STATUS_URL :completeBlock];
    
}

- (void) request:(NSString*)url :(void (^)(NSURLResponse*, NSData*, NSError*)) completeBlock
{
    if(IsEmptyString(url)){
        return;
    }
    NSURL *transformedUrl = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:transformedUrl];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:completeBlock];
    
}

@end
