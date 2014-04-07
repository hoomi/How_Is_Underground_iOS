//
//  LineStatus.h
//  How Is Underground
//
//  Created by Hooman Ostovari on 07/04/2014.
//  Copyright (c) 2014 Hooman Ostovari. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Line, Status;

@interface LineStatus : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * statusDetails;
@property (nonatomic, retain) Line *line;
@property (nonatomic, retain) Status *status;

@end
