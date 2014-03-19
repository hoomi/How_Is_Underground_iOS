//
//  UndergroundLinesTableViewController.m
//  How Is Underground
//
//  Created by Hooman Ostovari on 17/03/2014.
//  Copyright (c) 2014 Hooman Ostovari. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "UndergroundLinesTableViewController.h"
#import "LineTableViewCell.h"
#import "ServerCommunicator.h"
#import "TubeStatusPageViewController.h"
#import "LineStatus.h"
#import "Line.h"
#import "Status.h"
#import "StatusType.h"

@interface UndergroundLinesTableViewController ()
{
    LineStatus *currentLineStatus;
    NSFetchedResultsController *fetchedResultController;
    NSFetchRequest *fetchRequest;
    NSFetchRequest *checkFetchRequest;
    NSManagedObjectContext *managedObjectContext;
    
}
@end

@implementation UndergroundLinesTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    managedObjectContext = appDelegate.managedObjectContext;
    fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"LineStatus"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    self.tableView.contentInset = UIEdgeInsetsMake(20.0f, 0.0f, 0.0f, 0.0f);
    [ServerCommunicator requestLineStatus:^(NSURLResponse *reponse, NSData *data, NSError *error) {
        if (error != nil) {
            [NSLogger log:@"Failed to download line status"];
            return;
        }
        NSSet *registeredObjects = [managedObjectContext registeredObjects];
        for (NSManagedObject *object in registeredObjects.allObjects) {
            [managedObjectContext deleteObject:object];
            [managedObjectContext save:nil];
        }
        
        NSXMLParser *parser = [[NSXMLParser alloc]initWithData:data];
        [parser setDelegate:self];
        [parser parse];
    }];
    [self reloadData];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [[fetchedResultController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [fetchedResultController sections][section];
    // Return the number of rows in the section.
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LineCell";
    LineTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = (LineTableViewCell *)[LineTableViewCell cellFromNibNamed:@"LineTableViewCell"];
    }
    LineStatus *lineStatus = [fetchedResultController objectAtIndexPath:indexPath];
    [cell setLineName:lineStatus.line.name :[lineStatus.line.id intValue]];
    
    return cell;
}

#pragma mark - TableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TubeStatusPageViewController *nextController = [[TubeStatusPageViewController alloc] init];
    [self.navigationController pushViewController:nextController animated:YES];
    
}

#pragma mark - XML Parser delegate

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"LineStatus"]) {
        if (currentLineStatus != nil) {
            [self saveLineStatus];
        }
        currentLineStatus = [NSEntityDescription insertNewObjectForEntityForName:@"LineStatus" inManagedObjectContext:managedObjectContext];
        currentLineStatus.id = [NSNumber numberWithInt:[[attributeDict objectForKey:@"ID"] intValue]];
        currentLineStatus.statusDetails = [attributeDict objectForKey:@"StatusDetails"];
    } else if ([elementName isEqualToString:@"Line"]) {
        Line *line = [NSEntityDescription insertNewObjectForEntityForName:@"Line" inManagedObjectContext:managedObjectContext];
        line.id = [NSNumber numberWithInt:[[attributeDict objectForKey:@"ID"] intValue]];
        line.name = [attributeDict objectForKey:@"Name"];
        currentLineStatus.line = line;
    } else if ([elementName isEqualToString:@"Status"]) {
        currentLineStatus.status.id = [attributeDict objectForKey:@"ID"];
        currentLineStatus.status.cssClass = [attributeDict objectForKey:@"CssClass"];
        currentLineStatus.status.descriptions = [attributeDict objectForKey:@"Description"];
        currentLineStatus.status.isActive = [NSNumber numberWithBool:[[attributeDict objectForKey:@"IsActive"] boolValue]];
    } else if ([elementName isEqualToString:@"StatusType"]){
        currentLineStatus.status.statusType.id = [attributeDict objectForKey:@"ID"];
        currentLineStatus.status.statusType.descriptions = [attributeDict objectForKey:@"Description"];
    }
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    currentLineStatus = nil;
    [self reloadData];
}

#pragma mark - Utility functions

- (void)saveLineStatus
{
    if (currentLineStatus == nil)
    {
        return;
    }
    
    NSError *error = nil;
    if (checkFetchRequest == nil) {
        checkFetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"LineStatus"];
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:YES];
        [checkFetchRequest setSortDescriptors:@[sortDescriptor]];
    }
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"id == %@", currentLineStatus.id];
    [checkFetchRequest setPredicate:predicate];
    NSArray *array = [managedObjectContext executeFetchRequest:checkFetchRequest error:&error];
    if ([array count] > 1) {
        for (int i = [array count] - 1; i > 0 ; i--) {
            [managedObjectContext deleteObject:[array objectAtIndex:i]];
        }
    }
    if ([array count]>0)
    {
        NSManagedObject * interMediate = array[0];
        interMediate = currentLineStatus;
    }
    
        [managedObjectContext save:nil];
    }


- (void) reloadData
{
    if (fetchedResultController == nil) {
        fetchedResultController = [[NSFetchedResultsController alloc]
                                   initWithFetchRequest:fetchRequest
                                   managedObjectContext:managedObjectContext
                                   sectionNameKeyPath:nil
                                   cacheName:nil];
        fetchedResultController.delegate = self;
    }
    
    NSError *error = nil;
    [fetchedResultController performFetch:&error];
    
    if (error != nil) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    [self.tableView reloadData];
    
}



@end
