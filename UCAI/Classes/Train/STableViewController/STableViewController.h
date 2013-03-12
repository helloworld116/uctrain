//
// STableViewController.h
//  
// @author Shiki
//

#import <UIKit/UIKit.h>


@interface STableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
  
@protected
  
  BOOL isDragging;
  BOOL isLoadingMore;

}


// The view used for "load more"
@property (nonatomic, retain) UIView *footerView;

@property (nonatomic, retain) UITableView *tableView;
@property (readonly) BOOL isDragging;
@property (readonly) BOOL isLoadingMore;
@property (nonatomic) BOOL canLoadMore;

// Defaults to YES
@property (nonatomic) BOOL clearsSelectionOnViewWillAppear;

// Just a common initialize method
- (void) initialize;

#pragma mark - Load More

// The value of the height starting from the bottom that the user needs to scroll down to in order
// to trigger -loadMore. By default, this will be the height of -footerView.
- (CGFloat) footerLoadMoreHeight;

// Override to perform fetching of next page of data. It's important to call and get the value of
// of [super loadMore] first. If it's NO, -loadMore should be aborted.
- (BOOL) loadMore;

// Called when all the conditions are met and -loadMore will begin.
- (void) willBeginLoadingMore;

// Call to signal that "load more" was completed. This should be called so -isLoadingMore is
// properly set to NO.
- (void) loadMoreCompleted;

// Helper to show/hide -footerView
- (void) setFooterViewVisibility:(BOOL)visible;

#pragma mark - 

// A helper method that calls refreshCompleted and/or loadMoreCompleted if any are active.
- (void) allLoadingCompleted;

#pragma mark - 

- (void) releaseViewComponents;

@end
