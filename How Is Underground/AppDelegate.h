//
//  AppDelegate.h
//  How Is Underground
//
//  Created by Hooman Ostovari on 17/03/2014.
//  Copyright (c) 2014 Hooman Ostovari. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectContext* parentManagedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectContext* childManagedObjectContext;
@property (nonatomic, strong) NSURL *storeURL;

- (void)saveContext;

@end
