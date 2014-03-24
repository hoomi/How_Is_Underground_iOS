//
//  XmlParser.h
//  How Is Underground
//
//  Created by Hooman Ostovari on 24/03/2014.
//  Copyright (c) 2014 Hooman Ostovari. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XmlParser : NSObject<NSXMLParserDelegate>

-(void)parse:(NSURLResponse*)urlResponse :(NSData*)data :(void (^)(NSError*)) completeBlock;

@end
