//
//  XmlParser.m
//  How Is Underground
//
//  Created by Hooman Ostovari on 24/03/2014.
//  Copyright (c) 2014 Hooman Ostovari. All rights reserved.
//

#import "XmlParser.h"
#import "LineStatus.h"
#import "Line.h"
#import "Status.h"
#import "StatusType.h"
#import "AppDelegate.h"


@implementation XmlParser
{
    LineStatus* currentLineStatus;
    NSManagedObjectContext* managedObjectContext;
    NSXMLParser *parser;
    void(^currentCompleteBlock)(NSError *);
    NSFetchRequest* checkFetchRequest;
}

-(id)init
{
    self = [super init];
    if (self != nil) {
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        managedObjectContext = [appDelegate managedObjectContext:@"xmlParser"];
    }
    return self;
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"LineStatus"]) {
        [self initCurrentLineStatus:[[attributeDict objectForKey:@"ID"] intValue]];
        currentLineStatus.statusDetails = [attributeDict objectForKey:@"StatusDetails"];
    } else if ([elementName isEqualToString:@"Line"]) {
        Line *line = [NSEntityDescription insertNewObjectForEntityForName:@"Line" inManagedObjectContext:managedObjectContext];
        line.id = [NSNumber numberWithInt:[[attributeDict objectForKey:@"ID"] intValue]];
        line.name = [attributeDict objectForKey:@"Name"];
        currentLineStatus.line = line;
    } else if ([elementName isEqualToString:@"Status"]) {
        Status *status = [NSEntityDescription insertNewObjectForEntityForName:@"Status" inManagedObjectContext:managedObjectContext];
        status.id = [attributeDict objectForKey:@"ID"];
        status.cssClass = [attributeDict objectForKey:@"CssClass"];
        status.descriptions = [attributeDict objectForKey:@"Description"];
        status.isActive = [NSNumber numberWithBool:[[attributeDict objectForKey:@"IsActive"] boolValue]];
        currentLineStatus.status = status;
    } else if ([elementName isEqualToString:@"StatusType"]){
        StatusType *statusType = [NSEntityDescription insertNewObjectForEntityForName:@"StatusType" inManagedObjectContext:managedObjectContext];
        statusType.id = [NSNumber numberWithInt:[[attributeDict objectForKey:@"ID"] intValue]];
        statusType.descriptions = [attributeDict objectForKey:@"Description"];
        currentLineStatus.status.statusType = statusType;
    }
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    currentLineStatus = nil;
    if (currentCompleteBlock != nil) {
        currentCompleteBlock(nil);
        currentCompleteBlock = nil;
    }
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate saveContext:@"xmlParser"];
    
}

-(void)parse:(NSURLResponse *)urlResponse :(NSData *)data :(void (^)(NSError *))completeBlock
{
    if (data != nil) {
        currentCompleteBlock = completeBlock;
        parser = [[NSXMLParser alloc]initWithData:data];
        parser.delegate = self;
        [parser parse];
    } else {
        completeBlock([NSError errorWithDomain:NSPOSIXErrorDomain code:0 userInfo:nil]);
        currentCompleteBlock  = nil;
    }
}

#pragma mark - Utility functions

-(void) initCurrentLineStatus:(NSInteger)idValue
{
    NSError *error = nil;
    if (checkFetchRequest == nil) {
        checkFetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"LineStatus"];
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:YES];
        [checkFetchRequest setSortDescriptors:@[sortDescriptor]];
    }
     NSPredicate *predicate =[NSPredicate predicateWithFormat:@"id == %d", idValue];
    [checkFetchRequest setPredicate:predicate];
    NSArray *array = [managedObjectContext executeFetchRequest:checkFetchRequest error:&error];
    NSInteger count = [array count];
    if (count > 1) {
        for (int i = (unsigned)[array count] - 1; i > 0 ; i--) {
            [managedObjectContext deleteObject:[array objectAtIndex:i]];
        }
    }
    if (count <= 0) {
        currentLineStatus = [NSEntityDescription insertNewObjectForEntityForName:@"LineStatus" inManagedObjectContext:managedObjectContext];
    } else {
        currentLineStatus = array[0];
    }
     currentLineStatus.id = [NSNumber numberWithInt:idValue];
}



@end
