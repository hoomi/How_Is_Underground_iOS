//
//  UndergroundLineStatusViewController.m
//  How Is Underground
//
//  Created by Hooman Ostovari on 15/05/2014.
//  Copyright (c) 2014 Hooman Ostovari. All rights reserved.
//

#import "UndergroundLineStatusViewController.h"
#import "AppDelegate.h"
#import "LineTableViewCell.h"
#import "ServerCommunicator.h"
#import "PageContainerViewController.h"
#import "LineStatusViewController.h"
#import "LineStatus.h"
#import "Line.h"
#import "Status.h"
#import "StatusType.h"
#import "UIColor+UIColorExtension.h"
#import "TubeMapViewController.h"

@interface UndergroundLineStatusViewController ()

@end

@implementation UndergroundLineStatusViewController {
    
    NSFetchedResultsController *fetchedResultController;
    NSFetchRequest *fetchRequest;
    NSManagedObjectContext *managedObjectContext;
    IBOutletCollection(NSLayoutConstraint) NSArray *verticalSpacingAdTable;
    NSArray *hideAdBannerConstraints;
    
    LineStatusViewController* (^initControllerAt)(NSInteger index);
    NSInteger (^totalLineNumbers)(void);
    LineStatus* (^getLineStatusAt)(NSInteger index);
    void (^setSelectedRow)(NSInteger index);
}

#pragma mark - Init Functions

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initFetchController];
    }
    return self;
}

- (void) initBlocks
{
    if (initControllerAt != nil) {
        return;
    }
    __weak NSFetchedResultsController *tempFetchResultController = fetchedResultController;
    __weak UndergroundLineStatusViewController *tempSelf = self;
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

-(void) initFetchController
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    managedObjectContext = [appDelegate parentManagedObjectContext];
    fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"LineStatus"];
    NSSortDescriptor *alphabeticallDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"line.name" ascending:YES];
    NSSortDescriptor *delayDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"status.descriptions" ascending:NO];
    [fetchRequest setSortDescriptors:@[delayDescriptor,alphabeticallDescriptor]];
    fetchedResultController = [[NSFetchedResultsController alloc]
                               initWithFetchRequest:fetchRequest
                               managedObjectContext:managedObjectContext
                               sectionNameKeyPath:nil
                               cacheName:nil];
    fetchedResultController.delegate = self;
}

-(void) initHideBannerConstraints
{
    if (hideAdBannerConstraints == nil) {
        
        id tableView = self.tableView;
        NSDictionary *views = NSDictionaryOfVariableBindings(tableView);
        hideAdBannerConstraints = [NSLayoutConstraint
                                   constraintsWithVisualFormat:@"V:[tableView]-0-|"
                                   options:0
                                   metrics:nil
                                   views:views];
    }
}


#pragma mark - ViewController Callbacks

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initBlocks];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.navigationItem.title = @"Tube Lines";
    if (!IsIpad()) {
        [self showMapButton];
        self.adBannerView.delegate = self;
    } else {
        [self removeAdBanner];
    }
    [self showLoadingView];
    [ServerCommunicator requestLineStatus:^(NSError *error) {
        if (error != nil) {
            [NSLogger log:@"Failed to download line status"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self reloadData];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lineStatusUpdated) name:LINE_STATUS_UPDATED object:nil];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[fetchedResultController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [fetchedResultController sections][section];
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

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self rowSelected:indexPath];
}

#pragma mark - ADBannerViewDelegate
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    [NSLogger log:[NSString stringWithFormat:@"didFailToReceiveAdWithError: error %@ %@",error,[error userInfo]]];
}

- (void) bannerViewDidLoadAd:(ADBannerView *)banner
{
    [NSLogger log:(@"bannerViewDidLoadAd")];
    
}

#pragma mark - User Interaction functions

- (void)rowSelected:(NSIndexPath*)indexPath
{
    PageContainerViewController *nextController;
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

#pragma mark- Notification Observer

-(void) lineStatusUpdated
{
    [NSLogger log:@"UndergroundLinesTableViewController -> Line Status Updated"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadData];
        [self dismissLoadingView];
    });
    
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


-(void) removeAdBanner
{
    [self.view removeConstraints:verticalSpacingAdTable];
    [self.adBannerView removeFromSuperview];
    [self initHideBannerConstraints];
    [self.view addConstraints:hideAdBannerConstraints];
}


@end
