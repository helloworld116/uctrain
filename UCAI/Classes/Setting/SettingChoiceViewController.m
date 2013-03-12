//
//  SettingChoiceViewController.m
//  UCAI
//
//  Created by  on 12-1-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SettingChoiceViewController.h"
#import "AboutUsViewController.h"
#import "HotelCitySettingChoiceTableViewController.h"
#import "FlightCitySettingChoiceTableViewController.h"
#import "TrainCitySettingChoiceTableViewController.h"
#import "WeatherCitySettingChoiceTableViewController.h"
#import "ThemeChoiceTableViewController.h"
#import "PiosaFileManager.h"

@implementation SettingChoiceViewController

@synthesize bgImageView = _bgImageView;
@synthesize phoneButton = _phoneButton;
@synthesize choiceTableView = _choiceTableView;

@synthesize hotelDefaultCityNameLabel = _hotelDefaultCityNameLabel;
@synthesize flightDefaultStartedCityNameLabel = _flightDefaultStartedCityNameLabel;
@synthesize flightDefaultArrivedCityNameLabel = _flightDefaultArrivedCityNameLabel;
@synthesize trainDefaultStartedCityNameLabel = _trainDefaultStartedCityNameLabel;
@synthesize trainDefaultArrivedCityNameLabel = _trainDefaultArrivedCityNameLabel;
@synthesize weatherDefaultCityNameLabel = _weatherDefaultCityNameLabel;

- (id)init{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(updateTheme:) 
                                                     name:kThemeDidChangeNotification 
                                                   object:nil];
    }
    return self;
}

- (void)dealloc{
    [self.bgImageView release];
    [self.phoneButton release];
    [self.choiceTableView release];
    [self.hotelDefaultCityNameLabel release];
    [self.flightDefaultStartedCityNameLabel release];
    [self.flightDefaultArrivedCityNameLabel release];
    [self.trainDefaultStartedCityNameLabel release];
    [self.trainDefaultArrivedCityNameLabel release];
    [self.weatherDefaultCityNameLabel release];
    [super dealloc];
}

#pragma mark -
#pragma mark View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[super loadView];
	
	self.title = @"设置";
	
	//返回按钮
    NSString *backButtonNormalPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"backButton_normal" inDirectory:@"CommonView/NavigationItem"];
    NSString *backButtonHighlightedPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"backButton_highlighted" inDirectory:@"CommonView/NavigationItem"];
    UIButton * backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    backButton.tag = 101;
    [backButton setBackgroundImage:[UIImage imageNamed:backButtonNormalPath] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:backButtonHighlightedPath] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backOrHome:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    [backBarButtonItem release];
    [backButton release];
    
    //主页按钮
    NSString *homeButtonNormalPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"homeButton_normal" inDirectory:@"CommonView/NavigationItem"];
    NSString *homeButtonHighlightedPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"homeButton_highlighted" inDirectory:@"CommonView/NavigationItem"];
    UIButton * homeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    homeButton.tag = 102;
    [homeButton setBackgroundImage:[UIImage imageNamed:homeButtonNormalPath] forState:UIControlStateNormal];
    [homeButton setBackgroundImage:[UIImage imageNamed:homeButtonHighlightedPath] forState:UIControlStateHighlighted];
    [homeButton addTarget:self action:@selector(backOrHome:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *homeBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:homeButton];
    self.navigationItem.rightBarButtonItem = homeBarButtonItem;
    [homeBarButtonItem release];
    [homeButton release];
    
	//设置背景图片
    NSString *bgPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"background" inDirectory:@"CommonView"];
	UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:bgPath]];
    bgImageView.frame = CGRectMake(0, 0, 320, 416);
    self.bgImageView = bgImageView;
	[self.view addSubview:bgImageView];
	[bgImageView release];
	
	UITableView * uiTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 386) style:UITableViewStyleGrouped];
	uiTableView.backgroundColor = [UIColor clearColor];
	uiTableView.dataSource = self;
	uiTableView.delegate = self;
    self.choiceTableView = uiTableView;
	[self.view addSubview:uiTableView];
	[uiTableView release];
    
    //底部视图的设置
    UIView * bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 386, 320, 30)];
    bottomView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
    UIButton * phoneButton = [[UIButton alloc] initWithFrame:CGRectMake(82, 2, 156, 26)];
    NSString *phonecallButtonNormalPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"phonecall_normal" inDirectory:@"CommonView/BottomItem"];
    NSString *phonecallButtonHighlightedPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"phonecall_highlighted" inDirectory:@"CommonView/BottomItem"];
    [phoneButton setImage:[UIImage imageNamed:phonecallButtonNormalPath] forState:UIControlStateNormal];
    [phoneButton setImage:[UIImage imageNamed:phonecallButtonHighlightedPath] forState:UIControlStateHighlighted];
    [phoneButton addTarget:self action:@selector(phoneCall) forControlEvents:UIControlEventTouchUpInside];
    self.phoneButton = phoneButton;
    [bottomView addSubview:phoneButton];
    [self.view addSubview:bottomView];
    [phoneButton release];
    [bottomView release];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.choiceTableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString * hotelDefaultCityName = [userDefaults stringForKey:@"hotelDefaultCityName"];
    NSString * flightDefaultStartedCityName = [userDefaults stringForKey:@"flightDefaultStartedCityName"];
    NSString * flightDefaultArrivedCityName = [userDefaults stringForKey:@"flightDefaultArrivedCityName"];
    NSString * trainDefaultStartedCityName = [userDefaults stringForKey:@"trainDefaultStartedCityName"];
    NSString * trainDefaultArrivedCityName = [userDefaults stringForKey:@"trainDefaultArrivedCityName"];
    NSString * weatherDefaultCityName = [userDefaults stringForKey:@"weatherDefaultCityName"];
    
    self.hotelDefaultCityNameLabel.text = hotelDefaultCityName == nil ?@"深圳":hotelDefaultCityName;
    self.flightDefaultStartedCityNameLabel.text = flightDefaultStartedCityName == nil ?@"深圳":flightDefaultStartedCityName;
    self.flightDefaultArrivedCityNameLabel.text = flightDefaultArrivedCityName == nil ?@"北京":flightDefaultArrivedCityName;
    self.trainDefaultStartedCityNameLabel.text = trainDefaultStartedCityName == nil ?@"深圳":trainDefaultStartedCityName;
    self.trainDefaultArrivedCityNameLabel.text = trainDefaultArrivedCityName == nil ?@"北京":trainDefaultArrivedCityName;
    self.weatherDefaultCityNameLabel.text = weatherDefaultCityName == nil ?@"深圳":weatherDefaultCityName;
}

#pragma mark -
#pragma mark Custom

-(void)updateTheme:(NSNotification*)notif
{
    //设置背景图片
    NSString *bgPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"background" inDirectory:@"CommonView"];
    self.bgImageView.image = [UIImage imageNamed:bgPath];
    
    //返回按钮
    NSString *backButtonNormalPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"backButton_normal" inDirectory:@"CommonView/NavigationItem"];
    NSString *backButtonHighlightedPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"backButton_highlighted" inDirectory:@"CommonView/NavigationItem"];
    UIButton * backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    backButton.tag = 101;
    [backButton setBackgroundImage:[UIImage imageNamed:backButtonNormalPath] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:backButtonHighlightedPath] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backOrHome:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    [backBarButtonItem release];
    [backButton release];
    
    //主页按钮
    NSString *homeButtonNormalPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"homeButton_normal" inDirectory:@"CommonView/NavigationItem"];
    NSString *homeButtonHighlightedPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"homeButton_highlighted" inDirectory:@"CommonView/NavigationItem"];
    UIButton * homeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    homeButton.tag = 102;
    [homeButton setBackgroundImage:[UIImage imageNamed:homeButtonNormalPath] forState:UIControlStateNormal];
    [homeButton setBackgroundImage:[UIImage imageNamed:homeButtonHighlightedPath] forState:UIControlStateHighlighted];
    [homeButton addTarget:self action:@selector(backOrHome:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *homeBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:homeButton];
    self.navigationItem.rightBarButtonItem = homeBarButtonItem;
    [homeBarButtonItem release];
    [homeButton release];
    
    //设置电话拨打按钮的图片
    NSString *phonecallButtonNormalPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"phonecall_normal" inDirectory:@"CommonView/BottomItem"];
    NSString *phonecallButtonHighlightedPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"phonecall_highlighted" inDirectory:@"CommonView/BottomItem"];
    [self.phoneButton setImage:[UIImage imageNamed:phonecallButtonNormalPath] forState:UIControlStateNormal];
    [self.phoneButton setImage:[UIImage imageNamed:phonecallButtonHighlightedPath] forState:UIControlStateHighlighted];
    
}

- (void)phoneCall{
    if ([[UIApplication  sharedApplication] canOpenURL:[NSURL  URLWithString:@"tel://4006840060"]]) {
        UIActionSheet * phoneActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拨打电话40068 40060" otherButtonTitles:nil, nil];
        phoneActionSheet.delegate = self;
        [phoneActionSheet showInView:[UIApplication sharedApplication].keyWindow];
		[phoneActionSheet release];
    }
}

- (void)backOrHome:(UIButton *) button
{
    switch (button.tag) {
        case 101:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case 102:
            [self.navigationController popToRootViewControllerAnimated:YES];
            break;
    }
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 6;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 2;
            break;
        default:
            return 0;
            break;
    }
}


//设置表格单元的展现
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d%d",indexPath.section,indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        switch (indexPath.section) {
            case 0:
                switch (indexPath.row) {
                    case 0:{
                        UILabel * hotelDefaultCityShowLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 130, 35)];
                        hotelDefaultCityShowLabel.backgroundColor = [UIColor clearColor];
                        hotelDefaultCityShowLabel.font = [UIFont boldSystemFontOfSize:15];
                        hotelDefaultCityShowLabel.text = @"酒店默认入住城市:";
                        [cell.contentView addSubview:hotelDefaultCityShowLabel];
                        [hotelDefaultCityShowLabel release];
                        
                        UILabel * hotelDefaultCityNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 5, 120, 35)];
                        hotelDefaultCityNameLabel.backgroundColor = [UIColor clearColor];
                        hotelDefaultCityNameLabel.textColor = [UIColor grayColor];
                        hotelDefaultCityNameLabel.font = [UIFont systemFontOfSize:15];
                        self.hotelDefaultCityNameLabel = hotelDefaultCityNameLabel;
                        [cell.contentView addSubview:hotelDefaultCityNameLabel];
                        [hotelDefaultCityNameLabel release];
                    }
                        break;
                    case 1:{
                        UILabel * flightDefaultStartedCityShowLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 130, 35)];
                        flightDefaultStartedCityShowLabel.backgroundColor = [UIColor clearColor];
                        flightDefaultStartedCityShowLabel.font = [UIFont boldSystemFontOfSize:15];
                        flightDefaultStartedCityShowLabel.text = @"航班默认出发城市:";
                        [cell.contentView addSubview:flightDefaultStartedCityShowLabel];
                        [flightDefaultStartedCityShowLabel release];
                        
                        UILabel * flightDefaultStartedCityNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 5, 120, 35)];
                        flightDefaultStartedCityNameLabel.backgroundColor = [UIColor clearColor];
                        flightDefaultStartedCityNameLabel.textColor = [UIColor grayColor];
                        flightDefaultStartedCityNameLabel.font = [UIFont systemFontOfSize:15];
                        self.flightDefaultStartedCityNameLabel = flightDefaultStartedCityNameLabel;
                        [cell.contentView addSubview:flightDefaultStartedCityNameLabel];
                        [flightDefaultStartedCityNameLabel release];
                    }
                        break;
                    case 2:{
                        UILabel * flightDefaultArrivedCityShowLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 130, 35)];
                        flightDefaultArrivedCityShowLabel.backgroundColor = [UIColor clearColor];
                        flightDefaultArrivedCityShowLabel.font = [UIFont boldSystemFontOfSize:15];
                        flightDefaultArrivedCityShowLabel.text = @"航班默认目的城市:";
                        [cell.contentView addSubview:flightDefaultArrivedCityShowLabel];
                        [flightDefaultArrivedCityShowLabel release];
                        
                        UILabel * flightDefaultArrivedCityNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 5, 120, 35)];
                        flightDefaultArrivedCityNameLabel.backgroundColor = [UIColor clearColor];
                        flightDefaultArrivedCityNameLabel.textColor = [UIColor grayColor];
                        flightDefaultArrivedCityNameLabel.font = [UIFont systemFontOfSize:15];
                        self.flightDefaultArrivedCityNameLabel = flightDefaultArrivedCityNameLabel;
                        [cell.contentView addSubview:flightDefaultArrivedCityNameLabel];
                        [flightDefaultArrivedCityNameLabel release];
                    }
                        
                        break;
                    case 3:{
                        UILabel * trainDefaultStartedCityShowLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 130, 35)];
                        trainDefaultStartedCityShowLabel.backgroundColor = [UIColor clearColor];
                        trainDefaultStartedCityShowLabel.font = [UIFont boldSystemFontOfSize:15];
                        trainDefaultStartedCityShowLabel.text = @"列车默认出发城市:";
                        [cell.contentView addSubview:trainDefaultStartedCityShowLabel];
                        [trainDefaultStartedCityShowLabel release];
                        
                        UILabel * trainDefaultStartedCityNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 5, 120, 35)];
                        trainDefaultStartedCityNameLabel.backgroundColor = [UIColor clearColor];
                        trainDefaultStartedCityNameLabel.textColor = [UIColor grayColor];
                        trainDefaultStartedCityNameLabel.font = [UIFont systemFontOfSize:15];
                        self.trainDefaultStartedCityNameLabel = trainDefaultStartedCityNameLabel;
                        [cell.contentView addSubview:trainDefaultStartedCityNameLabel];
                        [trainDefaultStartedCityNameLabel release];
                    }
                        break;
                    case 4:{
                        UILabel * trainDefaultArrivedCityShowLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 130, 35)];
                        trainDefaultArrivedCityShowLabel.backgroundColor = [UIColor clearColor];
                        trainDefaultArrivedCityShowLabel.font = [UIFont boldSystemFontOfSize:15];
                        trainDefaultArrivedCityShowLabel.text = @"列车默认目的城市:";
                        [cell.contentView addSubview:trainDefaultArrivedCityShowLabel];
                        [trainDefaultArrivedCityShowLabel release];
                        
                        UILabel * trainDefaultArrivedCityNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 5, 120, 35)];
                        trainDefaultArrivedCityNameLabel.backgroundColor = [UIColor clearColor];
                        trainDefaultArrivedCityNameLabel.textColor = [UIColor grayColor];
                        trainDefaultArrivedCityNameLabel.font = [UIFont systemFontOfSize:15];
                        self.trainDefaultArrivedCityNameLabel = trainDefaultArrivedCityNameLabel;
                        [cell.contentView addSubview:trainDefaultArrivedCityNameLabel];
                        [trainDefaultArrivedCityNameLabel release];
                    }
                        break;
                    case 5:{
                        UILabel * weatherDefaultCityShowLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 130, 35)];
                        weatherDefaultCityShowLabel.backgroundColor = [UIColor clearColor];
                        weatherDefaultCityShowLabel.font = [UIFont boldSystemFontOfSize:15];
                        weatherDefaultCityShowLabel.text = @"天气默认查询城市:";
                        [cell.contentView addSubview:weatherDefaultCityShowLabel];
                        [weatherDefaultCityShowLabel release];
                        
                        UILabel * weatherDefaultCityNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 5, 120, 35)];
                        weatherDefaultCityNameLabel.backgroundColor = [UIColor clearColor];
                        weatherDefaultCityNameLabel.textColor = [UIColor grayColor];
                        weatherDefaultCityNameLabel.font = [UIFont systemFontOfSize:15];
                        self.weatherDefaultCityNameLabel = weatherDefaultCityNameLabel;
                        [cell.contentView addSubview:weatherDefaultCityNameLabel];
                        [weatherDefaultCityNameLabel release];
                    }
                        break;
                }
                
                break;
            case 1:
                switch (indexPath.row) {
                    case 0:
                        cell.textLabel.text = @"主题设置";
                        break;
                }
                break;
            case 2:
                switch (indexPath.row) {
                    case 0:
                        cell.textLabel.text = @"悠行宝不错,去评分支持下吧";
                        break;
                    case 1:
                        cell.textLabel.text = @"关于";
                        break;
                }
                break;
        }
	}
    
    cell.textLabel.highlightedTextColor = [PiosaColorManager themeColor];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    NSString *accessoryDisclosureIndicatorPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"accessoryDisclosureIndicator" inDirectory:@"CommonView/TableViewCell"];
    UIImageView * accessoryViewTemp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:accessoryDisclosureIndicatorPath]];
    accessoryViewTemp.frame = CGRectMake(0, 0, 10, 16);
    cell.accessoryView = accessoryViewTemp;
    [accessoryViewTemp release];
    
    if ([self.choiceTableView numberOfRowsInSection:indexPath.section] == 1) {
        NSString *tableViewCellSingleNormalPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"tableViewCell_single_normal" inDirectory:@"CommonView/TableViewCell"];
        NSString *tableViewCellSingleHighlightedPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"tableViewCell_single_highlighted" inDirectory:@"CommonView/TableViewCell"];
        cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:tableViewCellSingleNormalPath]] autorelease];
        cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:tableViewCellSingleHighlightedPath]] autorelease];
    } else {
        if (indexPath.row == 0) {
            NSString *tableViewCellTopNormalPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"tableViewCell_top_normal" inDirectory:@"CommonView/TableViewCell"];
            NSString *tableViewCellTopHighlightedPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"tableViewCell_top_highlighted" inDirectory:@"CommonView/TableViewCell"];
            cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:tableViewCellTopNormalPath]] autorelease];
            cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:tableViewCellTopHighlightedPath]] autorelease];
        } else if(indexPath.row == [self.choiceTableView numberOfRowsInSection:indexPath.section]-1){
            NSString *tableViewCellBottomNormalPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"tableViewCell_bottom_normal" inDirectory:@"CommonView/TableViewCell"];
            NSString *tableViewCellBottomHighlightedPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"tableViewCell_bottom_highlighted" inDirectory:@"CommonView/TableViewCell"];
            cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:tableViewCellBottomNormalPath]] autorelease];
            cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:tableViewCellBottomHighlightedPath]] autorelease];
        } else {
            NSString *tableViewCellCenterNormalPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"tableViewCell_center_normal" inDirectory:@"CommonView/TableViewCell"];
            NSString *tableViewCellCenterHighlightedPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"tableViewCell_center_highlighted" inDirectory:@"CommonView/TableViewCell"];
            cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:tableViewCellCenterNormalPath]] autorelease];
            cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:tableViewCellCenterHighlightedPath]] autorelease];
        }
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                {
                    HotelCitySettingChoiceTableViewController * hotelCitySettingChoiceTableViewController = [[HotelCitySettingChoiceTableViewController alloc] initWithStyle:UITableViewStylePlain];
                    [self.navigationController pushViewController:hotelCitySettingChoiceTableViewController animated:YES];
                    [hotelCitySettingChoiceTableViewController release];
                }
                    break;
                case 1:
                {
                    FlightCitySettingChoiceTableViewController * flightCitySettingChoiceTableViewController = [[FlightCitySettingChoiceTableViewController alloc] initWithCityType:1 andStyle:UITableViewStylePlain];
                    [self.navigationController pushViewController:flightCitySettingChoiceTableViewController animated:YES];
                    [flightCitySettingChoiceTableViewController release];
                }
                    break;
                case 2:
                {
                    FlightCitySettingChoiceTableViewController * flightCitySettingChoiceTableViewController = [[FlightCitySettingChoiceTableViewController alloc] initWithCityType:2 andStyle:UITableViewStylePlain];
                    [self.navigationController pushViewController:flightCitySettingChoiceTableViewController animated:YES];
                    [flightCitySettingChoiceTableViewController release];
                }
                    break;
                case 3:
                {
                    TrainCitySettingChoiceTableViewController * trainCitySettingChoiceTableViewController = [[TrainCitySettingChoiceTableViewController alloc] initWithCityType:1 andStyle:UITableViewStylePlain];
                    [self.navigationController pushViewController:trainCitySettingChoiceTableViewController animated:YES];
                    [trainCitySettingChoiceTableViewController release];
                }
                    break;
                case 4:
                {
                    TrainCitySettingChoiceTableViewController * trainCitySettingChoiceTableViewController = [[TrainCitySettingChoiceTableViewController alloc] initWithCityType:2 andStyle:UITableViewStylePlain];
                    [self.navigationController pushViewController:trainCitySettingChoiceTableViewController animated:YES];
                    [trainCitySettingChoiceTableViewController release];
                }
                    break;
                case 5:
                {
                    WeatherCitySettingChoiceTableViewController * weatherCitySettingChoiceTableViewController = [[WeatherCitySettingChoiceTableViewController alloc] initWithStyle:UITableViewStylePlain];
                    [self.navigationController pushViewController:weatherCitySettingChoiceTableViewController animated:YES];
                    [weatherCitySettingChoiceTableViewController release];
                }
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:{
                    ThemeChoiceTableViewController * themeChoiceTableViewController = [[ThemeChoiceTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
                    [self.navigationController pushViewController:themeChoiceTableViewController animated:YES];
                    [themeChoiceTableViewController release];
                }
                    break;
            }
            break;
        case 2:
            switch (indexPath.row) {
                case 0:
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=460915477"]];
                    break;
                case 1:
                {
                    AboutUsViewController *aboutUsViewController = [[AboutUsViewController alloc] init];
                    [self.navigationController pushViewController:aboutUsViewController animated:YES];
                    [AboutUsViewController release];
                }
                    break;
            }
            break;
    }
}


#pragma mark -
#pragma mark ActionSheet Delegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([actionSheet cancelButtonIndex] != buttonIndex) {
        //拨打客服电话
        [[UIApplication  sharedApplication] openURL:[NSURL  URLWithString:@"tel://4006840060"]];
    }
}

@end
