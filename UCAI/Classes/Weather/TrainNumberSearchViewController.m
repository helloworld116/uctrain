//
//  WeatherSearchViewController.m
//  UCAI

//
//  Created by  on 11-12-31.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//
#import "TrainNumberSearchViewController.h"
#import "TrainStationListResultViewController.h"

#import "CommonTools.h"
#import "GDataXMLNode.h"
#import "ASIFormDataRequest.h"
#import "StaticConf.h"
#import "PiosaFileManager.h"
#import "SBJsonParser.h"

@implementation TrainNumberSearchViewController

@synthesize cityNameLabel = _cityNameLabel;
@synthesize weatherCityTableView = _weatherCityTableView;
@synthesize cityLat = _cityLat;
@synthesize cityLng = _cityLng;
@synthesize provinceName = _provinceName;
@synthesize lineCode=_lineCode;
@synthesize txtLineCode=_txtLineCode;

- (void)dealloc{
    [self.cityNameLabel release];
    [self.weatherCityTableView release];
    [self.cityLat release];
    [self.cityLng release];
    [self.provinceName release];
    [self.lineCode release];
    [self.txtLineCode release];
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

- (void) weatherSearch{
    //隐藏键盘
    [self hideKeyboard:nil];
    
    _hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    _hud.bgRGB = [PiosaColorManager progressColor];
	[self.navigationController.view addSubview:_hud];
    _hud.delegate = self;
    _hud.minSize = CGSizeMake(135.f, 135.f);
    _hud.labelText = @"加载中...";
    [_hud show:YES];
    
    self.lineCode = self.txtLineCode.text;
    NSLog(@"line url is %@",kLineCode);
    ASIFormDataRequest *req = [[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString: kLineCode]] autorelease];
//    [req addRequestHeader:@"API-Version" value:API_VERSION];
    req.timeOutSeconds = TIME_OUT_SECONDS;//设置超时时间
    [req setDelegate:self];
    [req startAsynchronous]; // 执行异步post

}

#pragma mark -
#pragma mark View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[super loadView];
	
	self.title = @"车次查询";
	
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
    
//    UIButton *hiddenButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    hiddenButton.frame = CGRectMake(0, 120, 320, 416);
//    [hiddenButton addTarget:self action:@selector(hideKeyboard:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:hiddenButton];
////	[hiddenButton release];

	//设置背景图片
//    NSString *bgPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"background" inDirectory:@"CommonView"];
//	UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:bgPath]];
//    bgImageView.frame = CGRectMake(0, 0, 320, 416);
//    
//	[self.view addSubview:bgImageView];
//	[bgImageView release];
	
	UITableView * uiTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 416) style:UITableViewStyleGrouped];
    NSString *bgPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"background" inDirectory:@"CommonView"];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:bgPath]];
    uiTableView.backgroundView = bgImageView;
	uiTableView.backgroundColor = [UIColor clearColor];
	uiTableView.dataSource = self;
	uiTableView.delegate = self;
    
    UIButton *weatherSearchButton = [[UIButton alloc] init];
	[weatherSearchButton setFrame:CGRectMake(10, 80, 300, 40)];
	[weatherSearchButton setTitle:@"查    询" forState:UIControlStateNormal];
    [weatherSearchButton setTitleColor:[PiosaColorManager bigMethodFontNormalColor] forState:UIControlStateNormal];
    [weatherSearchButton setTitleColor:[PiosaColorManager bigMethodFontPressedColor] forState:UIControlStateHighlighted];
    NSString *bigButtonNormalPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"bigButton_normal" inDirectory:@"CommonView/MethodButton"];
    NSString *bigButtonHighlightedPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"bigButton_highlighted" inDirectory:@"CommonView/MethodButton"];
	[weatherSearchButton setBackgroundImage:[UIImage imageNamed:bigButtonNormalPath] forState:UIControlStateNormal];
	[weatherSearchButton setBackgroundImage:[UIImage imageNamed:bigButtonHighlightedPath] forState:UIControlStateHighlighted];
	[weatherSearchButton addTarget:self action:@selector(weatherSearch) forControlEvents:UIControlEventTouchUpInside];
	[uiTableView addSubview:weatherSearchButton];
	[weatherSearchButton release];
    
    self.weatherCityTableView = uiTableView;
	[self.view addSubview:uiTableView];
	[uiTableView release];
    
    //底部视图的设置
//    UIView * bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 386, 320, 30)];
//    bottomView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
//    UIButton * phoneButton = [[UIButton alloc] initWithFrame:CGRectMake(82, 2, 156, 26)];
//    NSString *phonecallButtonNormalPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"phonecall_normal" inDirectory:@"CommonView/BottomItem"];
//    NSString *phonecallButtonHighlightedPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"phonecall_highlighted" inDirectory:@"CommonView/BottomItem"];
//    [phoneButton setImage:[UIImage imageNamed:phonecallButtonNormalPath] forState:UIControlStateNormal];
//    [phoneButton setImage:[UIImage imageNamed:phonecallButtonHighlightedPath] forState:UIControlStateHighlighted];
//    [phoneButton addTarget:self action:@selector(phoneCall) forControlEvents:UIControlEventTouchUpInside];
//    [bottomView addSubview:phoneButton];
//    [self.view addSubview:bottomView];
//    [phoneButton release];
//    [bottomView release];
}

#pragma mark -
#pragma mark ASIHTTP Delegate Methods

// 响应有响应 : 但可能是错误响应, 如 404，或查询结果为空，则不跳转到下一个机票展示页面
- (void)requestFinished:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    
    [_hud hide:YES];
    NSData *data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init]; 
    id result = [jsonParser objectWithString:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]]; 
    [jsonParser release], jsonParser = nil;
    int status = [[result objectForKey:@"status"] intValue];
    int totalCount = [[[result objectForKey:@"pageInfo"] objectForKey:@"totalCount"] intValue];
    if (status==1&&totalCount>0) {
        TrainStationListResultViewController *trainStationListResultViewController = [[TrainStationListResultViewController alloc] init];
        trainStationListResultViewController.trainCode = self.lineCode;
        trainStationListResultViewController.trainDetail = result;
        [self.navigationController pushViewController:trainStationListResultViewController animated:YES];
        [trainStationListResultViewController release];
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
        hud.labelText = @"无满足条件的列车";
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
    return 1;
}


//设置表格单元的展现
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        switch (indexPath.section) {
            case 0:{
                NSString *tableViewCellSingleNormalPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"tableViewCell_single_normal" inDirectory:@"CommonView/TableViewCell"];
                NSString *tableViewCellSingleHighlightedPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"tableViewCell_single_highlighted" inDirectory:@"CommonView/TableViewCell"];
                cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:tableViewCellSingleNormalPath]] autorelease];
                cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:tableViewCellSingleHighlightedPath]] autorelease];
                
//                UILabel *cityName = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 30)];
//                cityName.backgroundColor = [UIColor clearColor];
//                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//                NSString * weatherDefaultCityName = [userDefaults stringForKey:@"weatherDefaultCityName"];
//                cityName.text = weatherDefaultCityName == nil ?@"请输入您要查询的车次":weatherDefaultCityName;
//                self.cityNameLabel = cityName;
//                [cell.contentView addSubview:cityName];
//                [cityName release];
//                
//                NSString * weatherDefaultCityLat = [userDefaults stringForKey:@"weatherDefaultCityLat"];
//                NSString * weatherDefaultCityLng = [userDefaults stringForKey:@"weatherDefaultCityLng"];
//                NSString * weatherDefaultProvinceName = [userDefaults stringForKey:@"weatherDefaultProvinceName"];
//                self.cityLat = weatherDefaultCityLat == nil ?@"22330000":weatherDefaultCityLat;
//                self.cityLng = weatherDefaultCityLng == nil ?@"114070000":weatherDefaultCityLng;
//                self.provinceName = weatherDefaultProvinceName == nil ?@"广东省":weatherDefaultProvinceName;
                
                UITextField *lineCode = [[UITextField alloc] initWithFrame:CGRectMake(10, 12, 300, 30)];
                lineCode.backgroundColor = [UIColor clearColor];
                lineCode.placeholder =@"请输入您要查询的车次";
                self.txtLineCode = lineCode;
                self.txtLineCode.delegate = self;
                [cell.contentView addSubview:lineCode];
                [lineCode release];
                
                NSString *accessoryDisclosureIndicatorPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"accessoryDisclosureIndicator" inDirectory:@"CommonView/TableViewCell"];
                UIImageView * accessoryViewTemp2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:accessoryDisclosureIndicatorPath]];
                accessoryViewTemp2.frame = CGRectMake(0, 0, 10, 16);
                cell.accessoryView = accessoryViewTemp2;
                [accessoryViewTemp2 release];
            }
                break;
        }
	}
    
    cell.textLabel.highlightedTextColor = [PiosaColorManager themeColor];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    NSString *tableViewCellSingleNormalPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"tableViewCell_single_normal" inDirectory:@"CommonView/TableViewCell"];
    NSString *tableViewCellSingleHighlightedPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"tableViewCell_single_highlighted" inDirectory:@"CommonView/TableViewCell"];
    cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:tableViewCellSingleNormalPath]] autorelease];
    cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:tableViewCellSingleHighlightedPath]] autorelease];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        
//    WeatherCityChoiceTableViewController *weatherCityChoiceTableViewController = [[WeatherCityChoiceTableViewController alloc] init];
//    weatherCityChoiceTableViewController.weatherSearchViewController = self;
//    [self.navigationController pushViewController:weatherCityChoiceTableViewController animated:YES];
//    [weatherCityChoiceTableViewController release];
//    
//    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}  

-(void)hideKeyboard:(id)sender
{
	[self.txtLineCode resignFirstResponder];
}

@end
