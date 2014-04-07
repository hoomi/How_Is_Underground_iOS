//
//  StatusType.h
//  How Is Underground
//
//  Created by Hooman Ostovari on 07/04/2014.
//  Copyright (c) 2014 Hooman Ostovari. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Status;

@interface StatusType : NSManagedObject

@property (nonatomic, retain) NSString * descriptions;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) Status *status;

@end
