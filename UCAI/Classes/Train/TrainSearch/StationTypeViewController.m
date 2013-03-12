

#import "StationTypeViewController.h"


#define kCellIdentifier  @"UITableViewCell"
#define kNavigationTitle @"请选择车站类型"


@interface StationTypeViewController()

@property (nonatomic, readonly, retain) NSDictionary *texts;

+ (NSDictionary*)data;

@end


@implementation StationTypeViewController {
@private
	NSDictionary *texts_;
}
@synthesize stationViewController=_stationViewController;


- (void)dealloc {
	[texts_ release];
	[super dealloc];
}


#pragma mark -
#pragma mark Property


- (NSDictionary*)texts {
	if (texts_ == nil) {
		texts_ = [[StationTypeViewController data] retain];
	}
	return texts_;
}


#pragma mark -


+ (NSDictionary*)data {
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                               @"不限",@"0", @"始发站",@"1", @"过路站",@"2", @"终点站",@"3", nil];
    return dict;
}


#pragma mark -
#pragma mark UITableViewController


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.texts count];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
									   reuseIdentifier:kCellIdentifier] autorelease];
	}
	
	NSString *text = [self.texts valueForKey:[NSString stringWithFormat:@"%d",indexPath.row ]];
	[cell.textLabel setText:text];
//	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	
	return cell;
}


- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    NSString *text = [self.texts valueForKey:[NSString stringWithFormat:@"%d",indexPath.row ]];
    self.stationViewController.lblStationType.text = text;
    if ([text isEqualToString:@"不限"]) {
        self.stationViewController.stationType = @"";
    }else if ([text isEqualToString:@"始发站"]) {
        self.stationViewController.stationType = @"start";
    }else if ([text isEqualToString:@"终点站"]) {
        self.stationViewController.stationType = @"end";
    }else if ([text isEqualToString:@"过路站"]) {
        self.stationViewController.stationType = @"pass";
    }
    CQMFloatingController *floatingController = [CQMFloatingController sharedFloatingController];
    [floatingController dismissAnimated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footer = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)] autorelease];
    footer.backgroundColor = [UIColor clearColor];
    return footer;
}
#pragma mark -
#pragma mark UIViewController


- (void)viewDidLoad {
	[super viewDidLoad];
	[self.navigationItem setTitle:kNavigationTitle];
}


@end
