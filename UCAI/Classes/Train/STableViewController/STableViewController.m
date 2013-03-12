//
// STableViewController.m
//
// @author Shiki
//

#import "STableViewController.h"

#define DEFAULT_HEIGHT_OFFSET 52.0f

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation STableViewController

@synthesize tableView;
@synthesize footerView;

@synthesize isDragging;
@synthesize isLoadingMore;

@synthesize canLoadMore;


@synthesize clearsSelectionOnViewWillAppear;

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) initialize
{
  
  canLoadMore = YES;
  
  clearsSelectionOnViewWillAppear = YES;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (id) init
{
  if ((self = [super init]))
    [self initialize];  
  return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (id) initWithCoder:(NSCoder *)aDecoder
{
  if ((self = [super initWithCoder:aDecoder]))
    [self initialize];
  return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) viewDidLoad
{
  [super viewDidLoad];
  
//  self.tableView = [[[UITableView alloc] init] autorelease];
//  tableView.frame = self.view.bounds;
//  tableView.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//  tableView.dataSource = self;
//  tableView.delegate = self;
//  
//  [self.view addSubview:tableView];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  if (clearsSelectionOnViewWillAppear) {
    NSIndexPath *selected = [self.tableView indexPathForSelectedRow];
    if (selected)
      [self.tableView deselectRowAtIndexPath:selected animated:animated];
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Load More

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setFooterView:(UIView *)aView
{
  if (!tableView)
    return;
  
  tableView.tableFooterView = nil;
  [footerView release]; footerView = nil;
  
  if (aView) {
    footerView = [aView retain];
    
    tableView.tableFooterView = footerView;
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) willBeginLoadingMore
{
  
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) loadMoreCompleted
{
  isLoadingMore = NO;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL) loadMore
{
  if (isLoadingMore)
    return NO;
  
  [self willBeginLoadingMore];
  isLoadingMore = YES;  
  return YES;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat) footerLoadMoreHeight
{
  if (footerView)
    return footerView.frame.size.height;
  else
    return DEFAULT_HEIGHT_OFFSET;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setFooterViewVisibility:(BOOL)visible
{
  if (visible && self.tableView.tableFooterView != footerView)
    self.tableView.tableFooterView = footerView;
  else if (!visible)
    self.tableView.tableFooterView = nil;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) allLoadingCompleted
{
  if (isLoadingMore)
    [self loadMoreCompleted];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIScrollViewDelegate

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
  isDragging = YES;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!isLoadingMore && canLoadMore) {
    CGFloat scrollPosition = scrollView.contentSize.height - scrollView.frame.size.height - scrollView.contentOffset.y;
    if (scrollPosition < [self footerLoadMoreHeight]) {
      [self loadMore];
    }
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDelegate

////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 0;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return nil;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) releaseViewComponents
{
  [footerView release]; footerView = nil;
  [tableView release]; tableView = nil;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) dealloc
{
  [self releaseViewComponents];
  [super dealloc];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) viewDidUnload
{
  [self releaseViewComponents];
  [super viewDidUnload];
}

@end