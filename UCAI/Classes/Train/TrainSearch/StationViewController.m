//
//  StationViewController.m
//  UCAI
//
//  Created by apple on 13-1-5.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "StationViewController.h"
#import "StationCityChoiceViewController.h"
#import "TrainSearchListResultViewController.h"
#import "StationTypeViewController.h"
#import "CQMFloatingController.h"
#import "CommonTools.h"
#import "GDataXMLNode.h"
#import "ASIFormDataRequest.h"
#import "StaticConf.h"
#import "PiosaFileManager.h"
#import "CustomHistory.h"
#import "SBJsonParser.h"

@implementation StationViewController
@synthesize lblStationName=_lblStationName;
@synthesize lblStationType=_lblStationType;
@synthesize stationName=_stationName;
@synthesize stationType=_stationType;
@synthesize cityTableView=_cityTableView;


- (void)dealloc{
    [self.cityTableView release];
    [self.stationType release];
    [self.stationName release];
    [self.lblStationType release];
    [self.lblStationName release];
    [super dealloc];
}

#pragma mark -
#pragma mark Custom

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

- (void) stationSearch{
    _hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    _hud.bgRGB = [PiosaColorManager progressColor];
	[self.navigationController.view addSubview:_hud];
    _hud.delegate = self;
    _hud.minSize = CGSizeMake(135.f, 135.f);
    _hud.labelText = @"加载中...";
    [_hud show:YES];
    
    self.stationName = self.lblStationName.text;

    ASIFormDataRequest *req = [[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString: kUrlOfStation]] autorelease];
    NSLog(@"url is %@",kUrlOfStation);
    NSLog(@"station type is %@",self.stationType);
    req.timeOutSeconds = TIME_OUT_SECONDS;//设置超时时间
    [req setDelegate:self];
    [req startAsynchronous]; // 执行异步post
    
}

#pragma mark -
#pragma mark View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[super loadView];
	
	self.title = @"车站查询";
	
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
//    NSString *homeButtonNormalPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"homeButton_normal" inDirectory:@"CommonView/NavigationItem"];
//    NSString *homeButtonHighlightedPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"homeButton_highlighted" inDirectory:@"CommonView/NavigationItem"];
//    UIButton * homeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
//    homeButton.tag = 102;
//    [homeButton setBackgroundImage:[UIImage imageNamed:homeButtonNormalPath] forState:UIControlStateNormal];
//    [homeButton setBackgroundImage:[UIImage imageNamed:homeButtonHighlightedPath] forState:UIControlStateHighlighted];
//    [homeButton addTarget:self action:@selector(backOrHome:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *homeBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:homeButton];
//    self.navigationItem.rightBarButtonItem = homeBarButtonItem;
//    [homeBarButtonItem release];
//    [homeButton release];
    
	//设置背景图片
//    NSString *bgPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"background" inDirectory:@"CommonView"];
//	UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:bgPath]];
//    bgImageView.frame = CGRectMake(0, 0, 320, 416);
//	[self.view addSubview:bgImageView];
//	[bgImageView release];
	
	UITableView * uiTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 416) style:UITableViewStyleGrouped];
    NSString *bgPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"background" inDirectory:@"CommonView"];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:bgPath]];
    uiTableView.backgroundView = bgImageView;
	uiTableView.dataSource = self;
	uiTableView.delegate = self;
    
    UIButton *weatherSearchButton = [[UIButton alloc] init];
	[weatherSearchButton setFrame:CGRectMake(10, 120, 300, 40)];
	[weatherSearchButton setTitle:@"查    询" forState:UIControlStateNormal];
    [weatherSearchButton setTitleColor:[PiosaColorManager bigMethodFontNormalColor] forState:UIControlStateNormal];
    [weatherSearchButton setTitleColor:[PiosaColorManager bigMethodFontPressedColor] forState:UIControlStateHighlighted];
    NSString *bigButtonNormalPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"bigButton_normal" inDirectory:@"CommonView/MethodButton"];
    NSString *bigButtonHighlightedPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"bigButton_highlighted" inDirectory:@"CommonView/MethodButton"];
	[weatherSearchButton setBackgroundImage:[UIImage imageNamed:bigButtonNormalPath] forState:UIControlStateNormal];
	[weatherSearchButton setBackgroundImage:[UIImage imageNamed:bigButtonHighlightedPath] forState:UIControlStateHighlighted];
	[weatherSearchButton addTarget:self action:@selector(stationSearch) forControlEvents:UIControlEventTouchUpInside];
	[uiTableView addSubview:weatherSearchButton];
	[weatherSearchButton release];
    
    self.cityTableView = uiTableView;
	[self.view addSubview:uiTableView];
	[uiTableView release];
}

#pragma mark -
#pragma mark ASIHTTP Delegate Methods

// 响应有响应 : 但可能是错误响应, 如 404，或查询结果为空，则不跳转到下一个机票展示页面
- (void)requestFinished:(ASIFormDataRequest *)request
{
    [_hud hide:YES];
    NSString *responseString = [request responseString];
    //    NSLog(@"responseString:%@", responseString);
    NSData *data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init]; 
    id result = [jsonParser objectWithString:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]]; 
    [jsonParser release], jsonParser = nil;
//    __autoreleasing NSError* error = nil;
//    #if __IPHONE_OS_VERSION_MAX_ALLOWED < 50000 
//        //iOS < 5 didn't have the JSON serialization class
//        SBJsonParser *jsonParser = [[SBJsonParser alloc] init]; 
//        result = [jsonParser objectWithString:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]]; 
//        [jsonParser release], jsonParser = nil;
//    #else 
//        result = [NSJSONSerialization JSONObjectWithData:data 
//                                                 options:kNilOptions error:&error];
//    #endif
    int status = [[result objectForKey:@"status"] intValue];
    int totalCount = [[[result objectForKey:@"pageInfo"] objectForKey:@"totalCount"] intValue];
    if (status==1&&totalCount>0) {
        TrainSearchListResultViewController *trainSearchListResultViewController = [[TrainSearchListResultViewController alloc] init];
        trainSearchListResultViewController.startedCityName = self.stationName;
        trainSearchListResultViewController.url = kUrlOfStation;
        trainSearchListResultViewController.data = result;
        [self.navigationController pushViewController:trainSearchListResultViewController animated:YES];
        [trainSearchListResultViewController release];
    }else {
        // 没有查询结果
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        hud.bgRGB = [PiosaColorManager progressColor];
        [self.navigationController.view addSubview:hud];
        hud.delegate = self;
        hud.minSize = CGSizeMake(135.f, 135.f);
        NSString *exclamationImagePath = [PiosaFileManager ucaiResourcesBoundleCommonFilePath:@"exclamation" inDirectory:@"CommonView/ProgressView"];
        UIImageView *exclamationImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:exclamationImagePath]];
        exclamationImageView.frame = CGRectMake(0, 0, 37, 37);
        hud.customView = exclamationImageView;
        [exclamationImageView release];
        hud.opacity = 1.0;
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"无满足条件的列车!";
        [hud show:YES];
        [hud hide:YES afterDelay:2];
    }
}

// 网络无响应
- (void)requestFailed:(ASIFormDataRequest *)request
{
    // 提示用户打开网络联接
    NSString *badFaceImagePath = [PiosaFileManager ucaiResourcesBoundleCommonFilePath:@"badFace" inDirectory:@"CommonView/ProgressView"];
    UIImageView *badFaceImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:badFaceImagePath]];
    badFaceImageView.frame = CGRectMake(0, 0, 37, 37);
    _hud.customView = badFaceImageView;
    [badFaceImageView release];
	_hud.mode = MBProgressHUDModeCustomView;
	_hud.labelText = @"网络连接失败啦";
    [_hud hide:YES afterDelay:3];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d%d", indexPath.row, indexPath.section];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        switch (indexPath.section) {
            case 0:
                switch (indexPath.row) {
                    case 0:{
                        UILabel *startCityTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 90, 25)];
                        startCityTitleLabel.backgroundColor = [UIColor clearColor];
                        startCityTitleLabel.textAlignment = UITextAlignmentCenter;
                        startCityTitleLabel.text = @"车    站:";
                        [cell.contentView addSubview:startCityTitleLabel];
                        [startCityTitleLabel release];
                        
                        UILabel * startCityLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 10, 200, 25)];
                        startCityLabel.backgroundColor = [UIColor clearColor];
                        startCityLabel.textColor = [UIColor grayColor];
                        startCityLabel.text = [CustomHistory getValueByKey:@"stationName"]==nil?@"深圳":[CustomHistory getValueByKey:@"stationName"];
                        self.lblStationName = startCityLabel;
                        [cell.contentView addSubview:startCityLabel];
                        [startCityLabel release];
                    }
                        break;
                    case 1:{
                        UILabel *arrivalCityTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 90, 25)];
                        arrivalCityTitleLabel.backgroundColor = [UIColor clearColor];
                        arrivalCityTitleLabel.textAlignment = UITextAlignmentCenter;
                        arrivalCityTitleLabel.text = @"类    型:";
                        [cell.contentView addSubview:arrivalCityTitleLabel];
                        [arrivalCityTitleLabel release];
                        
                        UILabel * arrivalCityLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 10, 200, 25)];
                        arrivalCityLabel.backgroundColor = [UIColor clearColor];
                        arrivalCityLabel.textColor = [UIColor grayColor];
                        arrivalCityLabel.text = [CustomHistory getValueByKey:@"stationType"]==nil?@"不限":[CustomHistory getValueByKey:@"stationType"];
                        self.lblStationType = arrivalCityLabel;
                        [cell.contentView addSubview:arrivalCityLabel];
                        [arrivalCityLabel release];
                    }
                        break;
                }
                
                NSString *accessoryDisclosureIndicatorPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"accessoryDisclosureIndicator" inDirectory:@"CommonView/TableViewCell"];
                UIImageView * accessoryViewTemp1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:accessoryDisclosureIndicatorPath]];
                accessoryViewTemp1.frame = CGRectMake(0, 0, 10, 16);
                cell.accessoryView = accessoryViewTemp1;
                [accessoryViewTemp1 release];
                break;
        }
    }
    
    if ([self.cityTableView numberOfRowsInSection:indexPath.section] == 1) {
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
        } else if(indexPath.row == [self.cityTableView numberOfRowsInSection:indexPath.section]-1){
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

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    switch (indexPath.section) {
		case 0:{
            switch (indexPath.row) {
                case 0:{
                    StationCityChoiceViewController *stationCityChoiceViewController = [[StationCityChoiceViewController alloc] init];
//                    trainCityChoiceTableViewController.trainSearchViewController = self;
                    stationCityChoiceViewController.stationViewContrller = self;
                    [self.navigationController pushViewController:stationCityChoiceViewController animated:YES];
                    [stationCityChoiceViewController release];
                }
                    break;
                case 1:{
                    // 1. Prepare a content view controller
                    StationTypeViewController *stationTypeViewController = [[[StationTypeViewController alloc] init] autorelease];
                    stationTypeViewController.stationViewController = self;
                    
                    // 2. Get shared floating controller
                    CQMFloatingController *floatingController = [CQMFloatingController sharedFloatingController];
                    
                    // 3. Show floating controller with specified content
                    [floatingController presentWithContentViewController:stationTypeViewController
                                                                animated:YES];
                }
                    break;
            }
		}
			break;
	}
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark ActionSheet Delegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([actionSheet cancelButtonIndex] != buttonIndex) {
        //拨打客服电话
        [[UIApplication  sharedApplication] openURL:[NSURL  URLWithString:@"tel://4006840060"]];
    }
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [hud removeFromSuperview];
    [hud release];
	hud = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
