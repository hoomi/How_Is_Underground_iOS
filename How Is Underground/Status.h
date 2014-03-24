//
//  Status.h
//  How Is Underground
//
//  Created by Hooman Ostovari on 24/03/2014.
//  Copyright (c) 2014 Hooman Ostovari. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class StatusType;

@interface Status : NSManagedObject

@property (nonatomic, retain) NSString * cssClass;
@property (nonatomic, retain) NSString * descriptions;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSNumber * isActive;
@property (nonatomic, retain) StatusType *statusType;

@end
