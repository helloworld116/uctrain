//
//  TrainSearchViewController.m
//  UCAI
//
//  Created by  on 12-1-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIView-ModalAnimationHelper.h"
#import "TrainCityChoiceTableViewController.h"
#import "TrainSearchListResultViewController.h"


#import "ASIFormDataRequest.h"
#import "GDataXMLNode.h"
#import "StaticConf.h"
#import "CommonTools.h"
#import "PiosaFileManager.h"
#import "CustomHistory.h"
#import "SBJsonParser.h"


@implementation TrainSearchViewController

@synthesize trainSearchTableView = _trainSearchTableView;
@synthesize startCityLabel = _startCityLabel;
@synthesize arrivalCityLabel = _arrivalCityLabel;
@synthesize startedDateLabel = _startedDateLabel;
@synthesize dateBar = _dateBar;
@synthesize datePicker = _datePicker;
@synthesize tmpUrl=_tmpUrl;

- (void)dealloc {
    [self.trainSearchTableView release];
    [self.startCityLabel release];
    [self.arrivalCityLabel release];
    [self.startedDateLabel release];
    [self.dateBar release];
    [self.datePicker release];
    [self.tmpUrl release];
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

- (void)dateCancel{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:self];
	self.dateBar.frame = CGRectMake(0, 416, 320, 40);
	self.datePicker.frame = CGRectMake(0, 446, 320, 216);
	[UIView commitModalAnimations];
    self.dateBar.hidden = YES;
    self.datePicker.hidden = YES;
    [self.trainSearchTableView setScrollEnabled:YES];
}

- (void)dateDone{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:self];
	self.dateBar.frame = CGRectMake(0, 416, 320, 40);
	self.datePicker.frame = CGRectMake(0, 446, 320, 216);
	[UIView commitModalAnimations];
    self.dateBar.hidden = YES;
    self.datePicker.hidden = YES;
	[self.trainSearchTableView setScrollEnabled:YES];
	
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	formatter.dateFormat = @"yyyy-MM-dd";
    self.startedDateLabel.text = [formatter stringFromDate:[self.datePicker date]];
    [formatter release];
}

#pragma mark -
#pragma mark View lifecycle

- (void)loadView {
    [super loadView];
	
    self.title = @"列车查询";
    
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
    NSString *bgPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"background" inDirectory:@"CommonView"];
	UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:bgPath]];
    bgImageView.frame = CGRectMake(0, 0, 320, 416);
	[self.view addSubview:bgImageView];
	[bgImageView release];
    
    UITableView * tempTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 416) style:UITableViewStyleGrouped];
    tempTableView.backgroundView = bgImageView;
    tempTableView.backgroundColor = [UIColor clearColor];
    tempTableView.dataSource = self;
    tempTableView.delegate = self;
    self.trainSearchTableView = tempTableView;
    [self.view addSubview:self.trainSearchTableView];
    [tempTableView release];
    
    UIButton *trainSearchButton = [[UIButton alloc] init];
	[trainSearchButton setFrame:CGRectMake(10, 120, 300, 40)];
	[trainSearchButton setTitle:@"查    询" forState:UIControlStateNormal];
    [trainSearchButton setTitleColor:[PiosaColorManager bigMethodFontNormalColor] forState:UIControlStateNormal];
    [trainSearchButton setTitleColor:[PiosaColorManager bigMethodFontPressedColor] forState:UIControlStateHighlighted];
    NSString *bigButtonNormalPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"bigButton_normal" inDirectory:@"CommonView/MethodButton"];
    NSString *bigButtonHighlightedPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"bigButton_highlighted" inDirectory:@"CommonView/MethodButton"];
	[trainSearchButton setBackgroundImage:[UIImage imageNamed:bigButtonNormalPath] forState:UIControlStateNormal];
	[trainSearchButton setBackgroundImage:[UIImage imageNamed:bigButtonHighlightedPath] forState:UIControlStateHighlighted];
	[trainSearchButton addTarget:self action:@selector(trainSearch) forControlEvents:UIControlEventTouchUpInside];
	[self.trainSearchTableView addSubview:trainSearchButton];
	[trainSearchButton release];
    
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
	
//	//初始化dataPicker
//	UIDatePicker * tempDatePicker = [[UIDatePicker alloc] init];
//	[tempDatePicker setFrame:CGRectMake(0, 446, 320, 100)];//大小固定为320＊216
//    tempDatePicker.hidden = YES;
//	tempDatePicker.datePickerMode = UIDatePickerModeDate;//时间选择只有日期
//    self.datePicker = tempDatePicker;
//	[self.view addSubview:self.datePicker];
//    [tempDatePicker release];
//	
//	//初始化dataBar
//	NSMutableArray *buttons = [[NSMutableArray alloc] init]; 
//	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle: @"取消" style:UIBarButtonItemStyleBordered target: self action: @selector(dateCancel)]; 
//	UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle: @"确定" style:UIBarButtonItemStyleBordered target: self action: @selector(dateDone)]; 
//	[buttons addObject:cancelButton];
//    [buttons addObject:flexibleSpace]; 
//    [buttons addObject:doneButton]; 
//	[cancelButton release];
//	[flexibleSpace release]; 
//	[doneButton release];
//    
//	UIToolbar * dataToolBar = [[UIToolbar alloc] init];
//	dataToolBar.tintColor = [PiosaColorManager tableViewPlainHeaderColor];
//	[dataToolBar setFrame:CGRectMake(0, 416, 320, 40)];
//    dataToolBar.hidden = YES;
//	[dataToolBar setItems:buttons animated:TRUE]; 
//    self.dateBar = dataToolBar;
//	[self.view addSubview:self.dateBar];
//    [dataToolBar release];
//	[buttons release];
}

#pragma mark -
#pragma mark ASIHTTP Response

-(void) requestFinished:(ASIHTTPRequest *) request{
    [_hud hide:YES];
    NSString *responseString = [request responseString];
    NSData *data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init]; 
    id result = [jsonParser objectWithString:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]]; 
    [jsonParser release], jsonParser = nil;
//    __autoreleasing NSError* error = nil;    
    int status = [[result objectForKey:@"status"] intValue];
    int totalCount = [[[result objectForKey:@"pageInfo"] objectForKey:@"totalCount"] intValue];
    if (status==1&&totalCount>0) {
        TrainSearchListResultViewController *trainSearchListResultViewController = [[TrainSearchListResultViewController alloc] init];
        trainSearchListResultViewController.startedCityName = self.startCityLabel.text;
        trainSearchListResultViewController.arrivedCityName = self.arrivalCityLabel.text;
        trainSearchListResultViewController.startDate = self.startedDateLabel.text;
        trainSearchListResultViewController.data = result;
        trainSearchListResultViewController.url = self.tmpUrl;
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

// 网络请求响应函数
//- (void) requestFinished:(ASIFormDataRequest *)request
//{
//    [_hud hide:YES];
//    NSString *responseString = [request responseString];
//    NSLog(@"responseString:%@", responseString);
//    if ((responseString != nil) && [responseString length] > 0) {
//        NSRange range = [responseString rangeOfString:@"gb2312"];
//        
//        // XML 解析,采用Google的GDataXMLNode.h 库
//        if (range.length > 0) { // 找到 gb23121, 替换成UTF8,否则解析不出来
//            responseString = [responseString stringByReplacingCharactersInRange:range withString:@"UTF8"];
//            self.trainSearchResponseModel = [ResponseParser loadTrainSearchResponse:[responseString dataUsingEncoding:NSUTF8StringEncoding]];
//        }
//        else { //不是gb2312则默认为UTF8,直接可以解析         
//            self.trainSearchResponseModel = [ResponseParser loadTrainSearchResponse:[request responseData]];
//        }
//        if ([self.trainSearchResponseModel.searchCode intValue] == 1 && [self.trainSearchResponseModel.iCount intValue]> 0) {
//            TrainSearchListResultViewController *trainSearchListResultViewController = [[TrainSearchListResultViewController alloc] init];
//            trainSearchListResultViewController.startedCityName = self.startCityLabel.text;
//            trainSearchListResultViewController.arrivedCityName = self.arrivalCityLabel.text;
//            trainSearchListResultViewController.trainSearchResponseModel = self.trainSearchResponseModel;
//            [self.navigationController pushViewController:trainSearchListResultViewController animated:YES];
//            [trainSearchListResultViewController release];
//            
//        } else {
//            // 没有查询结果
//            MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//            hud.bgRGB = [PiosaColorManager progressColor];
//            [self.navigationController.view addSubview:hud];
//            hud.delegate = self;
//            hud.minSize = CGSizeMake(135.f, 135.f);
//            NSString *exclamationImagePath = [PiosaFileManager ucaiResourcesBoundleCommonFilePath:@"exclamation" inDirectory:@"CommonView/ProgressView"];
//            UIImageView *exclamationImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:exclamationImagePath]];
//            exclamationImageView.frame = CGRectMake(0, 0, 37, 37);
//            hud.customView = exclamationImageView;
//            [exclamationImageView release];
//            hud.opacity = 1.0;
//            hud.mode = MBProgressHUDModeCustomView;
//            hud.labelText = @"无满足条件的列车!";
//            [hud show:YES];
//            [hud hide:YES afterDelay:2];
//        }
//    }
//}

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

- (void)trainSearch{
    _hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    _hud.bgRGB = [PiosaColorManager progressColor];
    _hud.bgRGB = [PiosaColorManager progressColor];
    [self.navigationController.view addSubview:_hud];
    _hud.delegate = self;
    _hud.minSize = CGSizeMake(135.f, 135.f);
    _hud.labelText = @"查询中...";
    [_hud show:YES];
    
    // 实名查询, 要把城市名字转为UTF-8格式
    NSString *fromCityName = [CommonTools EncodeUTF8Str:self.startCityLabel.text];
    NSString *toCityName = [CommonTools EncodeUTF8Str:self.arrivalCityLabel.text];
    
    [CustomHistory saveKey:@"station_station_startcity" withValue:self.startCityLabel.text];
    [CustomHistory saveKey:@"station_station_endcity" withValue:self.arrivalCityLabel.text];
    
    NSLog(@"request url is: %@", kUrlOfTrain);
    
    self.tmpUrl = kUrlOfTrain;
    ASIFormDataRequest *req = [[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString: kUrlOfTrain]] autorelease];
	req.timeOutSeconds = TIME_OUT_SECONDS;//设置超时时间
	[req setDelegate:self];
	[req startAsynchronous]; // 执行异步post
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    switch (section) {
//		case 0:
//			return 2;
//			break;
//		case 1:
//			return 1;
//			break;
//		default:
//			return 0;
//	}
    return 2;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d%d", indexPath.row, indexPath.section];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        switch (indexPath.row) {
            case 0:{
                UILabel *startCityTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 90, 25)];
                startCityTitleLabel.backgroundColor = [UIColor clearColor];
                startCityTitleLabel.textAlignment = UITextAlignmentCenter;
                startCityTitleLabel.text = @"出发城市:";
                [cell.contentView addSubview:startCityTitleLabel];
                [startCityTitleLabel release];
                
                UILabel * startCityLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 10, 200, 25)];
                startCityLabel.backgroundColor = [UIColor clearColor];
                startCityLabel.textColor = [UIColor grayColor];
                startCityLabel.text = [CustomHistory getValueByKey:@"station_station_startcity"]==nil?@"深圳":[CustomHistory getValueByKey:@"station_station_startcity"];
                self.startCityLabel = startCityLabel;
                [cell.contentView addSubview:startCityLabel];
                [startCityLabel release];
            }
                break;
            case 1:{
                UILabel *arrivalCityTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 90, 25)];
                arrivalCityTitleLabel.backgroundColor = [UIColor clearColor];
                arrivalCityTitleLabel.textAlignment = UITextAlignmentCenter;
                arrivalCityTitleLabel.text = @"目的城市:";
                [cell.contentView addSubview:arrivalCityTitleLabel];
                [arrivalCityTitleLabel release];
                
                UILabel * arrivalCityLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 10, 200, 25)];
                arrivalCityLabel.backgroundColor = [UIColor clearColor];
                arrivalCityLabel.textColor = [UIColor grayColor];
                arrivalCityLabel.text = [CustomHistory getValueByKey:@"station_station_endcity"]==nil?@"广州":[CustomHistory getValueByKey:@"station_station_endcity"];
                self.arrivalCityLabel = arrivalCityLabel;
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
    }
    
    if (indexPath.row == 0) {
        NSString *tableViewCellTopNormalPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"tableViewCell_top_normal" inDirectory:@"CommonView/TableViewCell"];
        NSString *tableViewCellTopHighlightedPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"tableViewCell_top_highlighted" inDirectory:@"CommonView/TableViewCell"];
        cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:tableViewCellTopNormalPath]] autorelease];
        cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:tableViewCellTopHighlightedPath]] autorelease];
    } else if(indexPath.row == [self.trainSearchTableView numberOfRowsInSection:indexPath.section]-1){
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
    
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    switch (indexPath.row) {
        case 0:{
            TrainCityChoiceTableViewController *trainCityChoiceTableViewController = [[TrainCityChoiceTableViewController alloc] initWithCityType:1];
            trainCityChoiceTableViewController.trainSearchViewController = self;
            [self.navigationController pushViewController:trainCityChoiceTableViewController animated:YES];
            [trainCityChoiceTableViewController release];
        }
            break;
        case 1:{
            TrainCityChoiceTableViewController *trainCityChoiceTableViewController = [[TrainCityChoiceTableViewController alloc] initWithCityType:2];
            trainCityChoiceTableViewController.trainSearchViewController = self;
            [self.navigationController pushViewController:trainCityChoiceTableViewController animated:YES];
            [trainCityChoiceTableViewController release];
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

@end
