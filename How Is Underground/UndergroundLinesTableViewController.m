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
#import "UIColor+UIColorExtension.h"

@class LineStatusViewController;

@interface UndergroundLinesTableViewController ()
{
    NSFetchedResultsController *fetchedResultController;
    NSFetchRequest *fetchRequest;
    NSManagedObjectContext *managedObjectContext;
    
    LineStatusViewController* (^initControllerAt)(NSInteger index);
    NSInteger (^totalLineNumbers)(void);
    LineStatus* (^getLineStatusAt)(NSInteger index);
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
    [self showLoadingView];
    [ServerCommunicator requestLineStatus:^(NSError *error) {
        if (error != nil) {
            [NSLogger log:@"Failed to download line status"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dismissLoadingView];
            });
            
            return;
        }
        [self lineStatusUpdated];
    }];
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    pageControl.backgroundColor = [UIColor whiteColor];
}

-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lineStatusUpdated) name:LINE_STATUS_UPDATED object:nil];
    NSLog(@"Connected to Wi-Fi: %d", [ConnectivityUtils isConnectedToWifi]);
    NSLog(@"Connected to Mobile network: %d", [ConnectivityUtils isConnectedtoMobileNetworks]);
    NSLog(@"Connected to internet: %d", [ConnectivityUtils hasInternetConnection]);
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
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadData];
        [self dismissLoadingView];
    });
    
}

#pragma mark - Utility functions

- (void)rowSelected:(NSIndexPath*)indexPath
{
    PageContainerViewController *nextController;
    // It means that it is an iPhone
    nextController = [[PageContainerViewController alloc] init];
    [self.navigationController pushViewController:nextController animated:YES];
    nextController.totalNumberOfLines = totalLineNumbers;
    nextController.selectedIndex =[Utils indexFrom:indexPath : self.tableView];
    nextController.initControllerAt = initControllerAt;
    nextController.getLineStatusAt = getLineStatusAt;
    nextController.setSelectedRow = setSelectedRow;
    [nextController refresh];
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(NSInteger)validateGivenIndex:(NSInteger)index
{
    NSInteger count = [[fetchedResultController fetchedObjects] count];
    
    if (count > 0) {
        index = index % count;
        if (index < 0) {
            index = count + index;
        }
    } else {
        index = 0;
    }
    return index;
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
    NSIndexPath *ipath = [self.tableView indexPathForSelectedRow];
    [self.tableView reloadData];
    [self.tableView selectRowAtIndexPath:ipath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void) initBlocks
{
    if (initControllerAt != nil) {
        return;
    }
    __weak NSFetchedResultsController *tempFetchResultController = fetchedResultController;
    __weak UndergroundLinesTableViewController *tempSelf = self;
    initControllerAt = ^LineStatusViewController*(NSInteger index){
        LineStatusViewController *nextController = [[LineStatusViewController alloc]initWithNibName:@"LineStatusViewController" bundle:[NSBundle mainBundle]]      ;
        index = [tempSelf validateGivenIndex:index];
        nextController.lineStatus = [tempFetchResultController objectAtIndexPath:[Utils indexPathOf:index :tempSelf.tableView]];
        nextController.index = index;
        return nextController;
    };
    
    totalLineNumbers = ^NSInteger {
        return [[tempFetchResultController fetchedObjects] count];
    };
    
    setSelectedRow = ^(NSInteger index){
        [tempSelf.tableView selectRowAtIndexPath:[Utils indexPathOf:index :tempSelf.tableView] animated:YES scrollPosition:UITableViewScrollPositionNone];
        
    };
    getLineStatusAt = ^LineStatus*(NSInteger index) {
        index = [tempSelf validateGivenIndex:index];
        return [tempFetchResultController objectAtIndexPath:[Utils indexPathOf:index :tempSelf.tableView]];
    };
}

@end
