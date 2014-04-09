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
#import "LineStatus.h"
#import "Line.h"
#import "Status.h"

#define MyModelURLFile          @"Line"
#define MySQLDataFileName       @"Line.sqlite"
#define REFRESH_INTERVAL        30.0
#define LINE_STATUS_TIMER_ID    1

@implementation AppDelegate
{
    NSFetchRequest* fetchRequest;
    NSMutableDictionary* threadsmanagedObjectCotextDic;
}

@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   
    [NSLogger log:[NSString stringWithFormat:@"Launched in background %d", UIApplicationStateBackground == application.applicationState]];
    threadsmanagedObjectCotextDic = [[NSMutableDictionary alloc]init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userSettingsChanged) name:NSUserDefaultsDidChangeNotification object:nil];
    return YES;
}

-(void)applicationWillTerminate:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:NOTIFICATION_ENABLED]) {
        [NSLogger log:@"Showing the notifications is disabled"];
        completionHandler(UIBackgroundFetchResultNoData);
    }
    [NSLogger log:@"Doing fetch in the background"];
    [ServerCommunicator requestLineStatus:^(NSError *error) {
        if (error != nil) {
            [NSLogger log:@"Failed to download line status"];
            completionHandler(UIBackgroundFetchResultFailed);
            return;
        }
        if ([[UIApplication sharedApplication]applicationState] ==  UIApplicationStateBackground) {
            [self showLocalNotification];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:LINE_STATUS_UPDATED object:nil];
        }
        completionHandler(UIBackgroundFetchResultNewData);
        
    }];
}

-(void)applicationWillEnterForeground:(UIApplication *)application
{
    [self requestLineStatusPeriodically];
    [self removePreviousNotifications];
    [[NSNotificationCenter defaultCenter] postNotificationName:LINE_STATUS_UPDATED object:nil];
}

-(void)applicationWillResignActive:(UIApplication *)application
{
    [[TimerManager getInstance] destroyAll];
    [application setMinimumBackgroundFetchInterval:([[NSUserDefaults standardUserDefaults] boolForKey:NOTIFICATION_ENABLED]?UIApplicationBackgroundFetchIntervalMinimum:UIApplicationBackgroundFetchIntervalNever)];
}


#pragma mark - Utility functions
-(void)userSettingsChanged
{
    BOOL enabled = [[NSUserDefaults standardUserDefaults] boolForKey:NOTIFICATION_ENABLED];
    [NSLogger log:[NSString stringWithFormat:@"Show notifications: %d",enabled]];
    if (enabled) {
        [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    } else {
        [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalNever];
    }
}
-(void)removePreviousNotifications
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}
- (void)invocationMethod {
    [NSLogger log:@"Timer was fired"];
    [ServerCommunicator requestLineStatus:^(NSError *error) {
        if (error != nil) {
            [NSLogger log:@"Failed to download line status"];
            return;
        }
        if ([[UIApplication sharedApplication]applicationState] ==  UIApplicationStateBackground) {
            [self showLocalNotification];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:LINE_STATUS_UPDATED object:nil];
        }
        
    }];
}

-(void) showLocalNotification
{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:NOTIFICATION_ENABLED]) {
        return;
    }
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger currentTime = [[NSDate date] timeIntervalSince1970];
    NSInteger lastMessageTime = [userDefaults integerForKey:LAST_NOTIF_TIME];
    NSString* lastMessage = [userDefaults stringForKey:LAST_NOTIF_MESSAGE];
    if (fetchRequest == nil) {
        fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"LineStatus"];
        NSSortDescriptor *lineNamedescriptor = [NSSortDescriptor sortDescriptorWithKey:@"line.name" ascending:YES];
        NSSortDescriptor *lineStatusDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"status.descriptions" ascending:NO];
        [fetchRequest setSortDescriptors:@[lineNamedescriptor,lineStatusDescriptor]];
        NSPredicate *predicate =[NSPredicate predicateWithFormat:@"status.descriptions == %@ OR status.descriptions == %@ OR status.descriptions == %@", SEVERE_DELAYS_STRING, MINOR_DELAYS_STRING,PART_SUSPENDED];
        [fetchRequest setPredicate:predicate];
        
    }
    NSError *error;
    NSArray *array = [[self managedObjectContext:@"notification"] executeFetchRequest:fetchRequest error:&error];
    if (error != nil) {
        [NSLogger log:[error localizedDescription]];
        return;
    }
    NSString *message = @"";
    if ([array count]> 0) {
        
        for (LineStatus *lineStatus in array) {
            message = [message stringByAppendingFormat:@"%@ : %@ \n",lineStatus.line.name,lineStatus.status.descriptions];
        }
    } else {
        message = @"Good service on all lines";
    }
    [NSLogger log:message];
    if ([lastMessage isEqualToString:message]) {
        if (currentTime - lastMessageTime < NOTIFICATION_SHOW_INTERVAL) {
            return;
        }
    }
    [userDefaults setInteger:currentTime forKey:LAST_NOTIF_TIME];
    [userDefaults setObject:message forKey:LAST_NOTIF_MESSAGE];
    [self removePreviousNotifications];
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif) {
        localNotif.alertBody = message;
        localNotif.alertAction = NSLocalizedString(@"Read Message", nil);
        localNotif.soundName = @"alarmsound.caf";
        localNotif.applicationIconBadgeNumber = 1;
        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotif];
    }
}
-(void) requestLineStatusPeriodically
{
    NSMethodSignature *methodSignature = [self methodSignatureForSelector:@selector(invocationMethod)];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    [invocation setTarget:self];
    [invocation setSelector:@selector(invocationMethod)];
    [[TimerManager getInstance] scheduledTimerWithTimeInterval:REFRESH_INTERVAL invocation:invocation repeats:YES id:  LINE_STATUS_TIMER_ID];
}

- (void)saveContext:(NSString*)name
{
    NSError *error = nil;
    [self.persistentStoreCoordinator lock];
    @try {
        NSManagedObjectContext *managedObjectContext = [self managedObjectContext:name];
        if (managedObjectContext != nil) {
            if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
        }
    }
    @catch (NSException *exception) {
        [NSLogger log:[NSString stringWithFormat:@"%@",[exception description]]];
    }
    @finally {
        [self.persistentStoreCoordinator unlock];
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

- (NSManagedObjectContext *)managedObjectContext:(NSString*)name
{
    NSManagedObjectContext* managedObject = [threadsmanagedObjectCotextDic objectForKey:name];
    if ( managedObject != nil) {
        return managedObject;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObject = [[NSManagedObjectContext alloc] init];
        [managedObject setPersistentStoreCoordinator:coordinator];
        [threadsmanagedObjectCotextDic setObject:managedObject forKey:name];
    }
    return managedObject;
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
