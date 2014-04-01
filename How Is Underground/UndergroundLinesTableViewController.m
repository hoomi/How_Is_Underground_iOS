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
#import "PageContainerViewController.h"
#import "LineStatusViewController.h"
#import "LineStatus.h"
#import "Line.h"
#import "Status.h"
#import "StatusType.h"
#import "DetailsViewManager.h"

@class LineStatusViewController;

@interface UndergroundLinesTableViewController ()
{
    NSFetchedResultsController *fetchedResultController;
    NSFetchRequest *fetchRequest;
    NSManagedObjectContext *managedObjectContext;
    DetailsViewManager *detailsViewManager;
    
    LineStatusViewController* (^getControllerAt)(NSInteger index);
    NSInteger (^totalLineNumbers)(void);
    LineStatusViewController* (^getSelectedController)();
    void (^setSelectedRow)(NSInteger index);
    
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
    NSSortDescriptor *alphabeticallDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"line.name" ascending:YES];
    NSSortDescriptor *delayDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"status.descriptions" ascending:NO];
    [fetchRequest setSortDescriptors:@[delayDescriptor,alphabeticallDescriptor]];
    [ServerCommunicator requestLineStatus:^(NSError *error) {
        if (error != nil) {
            [NSLogger log:@"Failed to download line status"];
            return;
        }
        __weak UndergroundLinesTableViewController *tempSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [tempSelf reloadData];
            if ([tempSelf.tableView indexPathForSelectedRow] == nil && IsIpad()) {
                [tempSelf initBlocks];
                NSIndexPath *indexPath =[Utils indexPathOf:0 :tempSelf.tableView];
                if (indexPath != nil) {
                    [tempSelf rowSelected:indexPath];
                    setSelectedRow(0);
                }
            }
        });
    }];
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    pageControl.backgroundColor = [UIColor whiteColor];
}

-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lineStatusUpdated) name:LINE_STATUS_UPDATED object:nil];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    [cell setLineStatus:lineStatus.status.descriptions];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

#pragma mark - TableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self initBlocks];
    [self rowSelected:indexPath];
    
}

#pragma mark- Notification Observer

-(void) lineStatusUpdated
{
    [NSLogger log:@"UndergroundLinesTableViewController -> Line Status Updated"];
    [self reloadData];
}

#pragma mark - Utility functions

- (void)rowSelected:(NSIndexPath*)indexPath
{
    PageContainerViewController *nextController;
    if (!IsIpad()) {
        nextController = [[PageContainerViewController alloc] init];
        [self.navigationController pushViewController:nextController animated:YES];
    } else {
        [DetailsViewManager sharedDetailsViewManager].splitViewController = self.splitViewController;
        UIViewController *temp = [DetailsViewManager sharedDetailsViewManager].currentLineStatusController;
        if (temp == nil || ![temp isMemberOfClass:[PageContainerViewController class]]) {
            nextController = [[PageContainerViewController alloc] init];
            [[DetailsViewManager sharedDetailsViewManager] setCurrentLineStatusController:nextController];
        } else {
            nextController = (PageContainerViewController*)temp;
        }
    }
    nextController.totalNumberOfLines = totalLineNumbers;
    nextController.selectedIndex =[Utils indexFrom:indexPath : self.tableView];
    nextController.getControllerAt = getControllerAt;
    nextController.setSelectedRow = setSelectedRow;
    [nextController refresh];
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

- (void) initBlocks
{
    if (getControllerAt != nil) {
        return;
    }
    __weak NSFetchedResultsController *temp = fetchedResultController;
    __weak UndergroundLinesTableViewController *tempSelf = self;
    getControllerAt = ^LineStatusViewController*(NSInteger index){
        LineStatusViewController *nextController = [[LineStatusViewController alloc]initWithNibName:@"LineStatusViewController" bundle:[NSBundle mainBundle]]      ;
        
        NSInteger count = [[temp fetchedObjects] count];
        
        if (count > 0) {
            index = index % count;
            if (index < 0) {
                index = count + index;
            }
        }
        
        nextController.lineStatus = [temp objectAtIndexPath:[Utils indexPathOf:index :tempSelf.tableView]];
        nextController.index = index;
        return nextController;
    };
    
    totalLineNumbers = ^NSInteger {
        return [[temp fetchedObjects] count];
    };
    
    getSelectedController = ^LineStatusViewController* {
        LineStatusViewController *nextController = [[LineStatusViewController alloc]initWithNibName:@"LineStatusViewController" bundle:[NSBundle mainBundle]];
        nextController.lineStatus = [temp objectAtIndexPath:[tempSelf.tableView indexPathForSelectedRow]];
        
        return nextController;
    };
    setSelectedRow = ^(NSInteger index){
        [tempSelf.tableView selectRowAtIndexPath:[Utils indexPathOf:index :tempSelf.tableView] animated:YES scrollPosition:UITableViewScrollPositionNone];
        
    };
}

@end
