//
//  StatusType.h
//  How Is Underground
//
//  Created by Hooman Ostovari on 24/03/2014.
//  Copyright (c) 2014 Hooman Ostovari. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface StatusType : NSManagedObject

@property (nonatomic, retain) NSString * descriptions;
@property (nonatomic, retain) NSNumber * id;

@end
