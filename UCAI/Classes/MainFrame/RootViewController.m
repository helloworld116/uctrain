//
//  RootViewController1.m
//  UCAI
//
//  Created by apple on 13-1-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "ADViewController.h"
#import "CommonTools.h"

@interface RootViewController ()

@end

@implementation RootViewController
@synthesize scrollView=_scrollView;
@synthesize segment=_segment;
@synthesize stationViewController=_stationViewController;
@synthesize trainSearchViewController=_trainSearchViewController;
@synthesize weatherSearchViewController=_weatherSearchViewController;
@synthesize adview=_adview;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView{
    [super loadView];
    //修改导航栏主题的颜色
    self.navigationController.navigationBar.tintColor = [PiosaColorManager barColor];
    
    self.segment = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"站站查询", @"车次查询", @"车站查询",nil]];
    self.segment.segmentedControlStyle = UISegmentedControlStyleBar;
    self.segment.tintColor = [PiosaColorManager barColor];
//    self.segment.tintColor = [UIColor whiteColor];
    self.segment.selectedSegmentIndex = 0;
    self.segment.frame = CGRectMake(0, 20, self.view.frame.size.width, 44);
    CGFloat width = self.view.frame.size.width/3;
    [self.segment setWidth:width forSegmentAtIndex:0];
    [self.segment setWidth:width forSegmentAtIndex:1];
    [self.segment setWidth:width+10 forSegmentAtIndex:2];
//    [[[self.segment subviews] objectAtIndex:0] setTintColor:[UIColor colorWithRed:25.0/255.0 green:127.0/255.0 blue:0.0/255.0 alpha:1.0]];
    [self.segment addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];   
//    self.navigationItem.titleView = self.segment;
    UIBarButtonItem *homeBarItem = [[UIBarButtonItem alloc] initWithCustomView:self.segment];
    self.navigationItem.rightBarButtonItem = homeBarItem;
}

-(void) segmentedControlChangedValue:(id)sender{
    int selectIndex = [sender selectedSegmentIndex];
    self.scrollView.contentOffset = CGPointMake(self.view.frame.size.width*selectIndex, 0);
}


#pragma mark- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int contentOffsetX = (int)scrollView.contentOffset.x;
    int width = (int)scrollView.frame.size.width;
    int x = -1; 
    if (contentOffsetX%width==0) {
        x = contentOffsetX/width ;
        self.segment.selectedSegmentIndex = x;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:50];
        [UIView commitAnimations];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //设置背景图片
    NSString *bgPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"background" inDirectory:@"CommonView"];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:bgPath]];
    bgImageView.frame = self.view.bounds;
    [self.view addSubview:bgImageView];
    [bgImageView release];
    
    // Initialization code
    CGRect rect = self.view.bounds;
    NSLog(@"the rect height is %f",rect.size.height);
    self.scrollView = [[[UIScrollView alloc] initWithFrame:rect] autorelease];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width*3, self.scrollView.frame.size.height);
    [self.view addSubview:self.scrollView];
    
    self.trainSearchViewController = [[TrainSearchViewController alloc] init];
    self.trainSearchViewController.view.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    [self.scrollView addSubview:self.trainSearchViewController.view];
//    [self.trainSearchViewController didMoveToParentViewController:self];
    [self addChildViewController:self.trainSearchViewController];
    [self.trainSearchViewController release];
    
    self.weatherSearchViewController = [[TrainNumberSearchViewController alloc] init];
    self.weatherSearchViewController.view.frame = CGRectMake(self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    [self.scrollView addSubview:self.weatherSearchViewController.view];
//    [self.weatherSearchViewController didMoveToParentViewController:self];
    [self addChildViewController:self.weatherSearchViewController];
    [self.weatherSearchViewController release];
    
    self.stationViewController = [[StationViewController alloc] init];
    self.stationViewController.view.frame = CGRectMake(self.scrollView.frame.size.width*2, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    [self.scrollView addSubview:self.stationViewController.view];
//    [self.stationViewController didMoveToParentViewController:self];
    [self addChildViewController:self.stationViewController];
    [self.stationViewController release];

#if showAd
    self.adview = [[WQAdView alloc] init];
    self.adview.delegate = self;
    [self.adview setFrame:CGRectMake(0, 366, 320, 50)];
//    adview.backgroundColor = [UIColor redColor];
    [self.adview startWithAdSlotID:kAdslotID AccountKey:kAccountKey InViewController:self.navigationController];
    [self.view addSubview:self.adview];
    [self.adview release];
#endif
}

- (void)viewDidUnload
{
    self.segment = nil;
    self.stationViewController= nil;
    self.weatherSearchViewController = nil;
    self.trainSearchViewController = nil;
    self.scrollView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

//-(void)viewWillDisappear:(BOOL)animated{
////    UIView *releaseView = [self.view viewWithTag:100];
////    [releaseView removeFromSuperview];
////    [releaseView release];
////    [releaseView release];
//    NSLog(@"rootviewcontroller subviews is %@",[self.view subviews]);
//    NSLog(@"rootviewcontroller viewWillDisapper");
//}
//
//-(void)viewDidDisappear:(BOOL)animated{
//    NSLog(@"rootviewcontroller viewDidDisapper");
//}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) dealloc{
    [self.segment release];
    [self.stationViewController release];
    [self.weatherSearchViewController release];
    [self.trainSearchViewController release];
    [self.scrollView release];
    self.adview.delegate = nil;
    [self.adview release];
    [super dealloc];
}

//广告视图获取广告成功
- (void)onWQAdReceived:(WQAdView *)adview{
    NSLog(@"广告视图获取广告成功");
}

//广告视图获取广告失败
- (void)onWQAdFailed:(WQAdView *)adview{
    NSLog(@"广告视图获取广告失败");
//    [self.adview startWithAdSlotID:kAdslotID AccountKey:kAccountKey InViewController:self.trainSearchViewController];
}


//广告视图将要关闭
- (void)onWQAdDismiss:(WQAdView *)adview{
    NSLog(@"广告视图将要关闭");
}


//广告视图获取缓慢提醒
- (void)onWQAdLoadTimeout:(WQAdView*) adview{
    NSLog(@"广告视图获取缓慢提醒");
}


@end
