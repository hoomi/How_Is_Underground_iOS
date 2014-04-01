//
//  AppDelegate.m
//  How Is Underground
//
//  Created by Hooman Ostovari on 17/03/2014.
//  Copyright (c) 2014 Hooman Ostovari. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "TimerManager.h"
#import "ServerCommunicator.h"

#define MyModelURLFile          @"Line"
#define MySQLDataFileName       @"Line.sqlite"
#define REFRESH_INTERVAL        120.0
#define LINE_STATUS_TIMER_ID    1

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self requestLineStatusPeriodically];
    return YES;
}

-(void)applicationWillTerminate:(UIApplication *)application
{
    [[TimerManager getInstance] destroyAll];
}

- (void)invocationMethod:(NSDate *)date {
    [ServerCommunicator requestLineStatus:^(NSError *error) {
        if (error != nil) {
            [NSLogger log:@"Failed to download line status"];
            return;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:LINE_STATUS_UPDATED object:nil];
    }];

}


-(void) requestLineStatusPeriodically
{
      NSMethodSignature *methodSignature = [self methodSignatureForSelector:@selector(invocationMethod:)];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    [invocation setTarget:self];
    [invocation setSelector:@selector(invocationMethod:)];
    [[TimerManager getInstance] scheduledTimerWithTimeInterval:REFRESH_INTERVAL invocation:invocation repeats:YES id:  LINE_STATUS_TIMER_ID];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

- (void)deleteCoreDataDatabase
{
    NSError *error;
    [[NSFileManager defaultManager]removeItemAtURL:self.storeURL error:&error];
    if (error)
        NSLog(@"error deleting: %@", [error localizedDescription]);
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:MyModelURLFile withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
//    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:MySQLDataFileName];
    
    self.storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:MySQLDataFileName];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:self.storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
