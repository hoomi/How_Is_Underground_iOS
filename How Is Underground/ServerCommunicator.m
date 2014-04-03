//
//  ServerCommunicator.m
//  How Is Underground
//
//  Created by Hooman Ostovari on 18/03/2014.
//  Copyright (c) 2014 Hooman Ostovari. All rights reserved.
//

#import "ServerCommunicator.h"
#import "XmlParser.h"

#define TIMEOUT_INTERVAL 5.0
@implementation ServerCommunicator
{
}

+ (void) requestLineStatus :(void (^)(NSError*)) completeBlock
{
    [self request:UNDERGROUND_STATUS_URL :completeBlock];
    
}

+ (void) request:(NSString*)url :(void (^)(NSError*)) completeBlock
{
    if(IsEmptyString(url)){
        return;
    }
    NSURL *transformedUrl = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:transformedUrl];
    [request setTimeoutInterval:TIMEOUT_INTERVAL];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse* urlResponse, NSData* data, NSError *error){
        if(error == nil){
            [[[XmlParser alloc] init] parse:urlResponse :data :completeBlock];
        } else {
            completeBlock(error);
        }
    }];
    
}

@end
