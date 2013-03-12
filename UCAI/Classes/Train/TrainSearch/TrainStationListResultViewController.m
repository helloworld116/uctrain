//
//  TrainStationListResultViewController.m
//  UCAI
//
//  Created by  on 12-1-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "QuartzCore/QuartzCore.h"

#import "TrainStationListResultViewController.h"

#import "PiosaFileManager.h"
#import "CommonTools.h"

#define kIDTag 101			//排序编号
#define kStationName 102    //站名
#define kCostTime 103       //运行时间，时间格式为“HH:mm”，HH表示小时数，mm表示分钟数
#define kArrTime 104        //到达时间，时间格式为“HH:mm”
#define kGoTime 105         //发车时间，时间格式为“HH:mm”
#define kYZTag 106          //硬座票价
#define kRZTag 107          //软座票价
#define kRZ1Tag 108         //一等软座票价
#define kRZ2Tag 109         //二等软座票价
#define kYWSTag 110         //硬卧上铺票价
#define kYWZTag 111         //硬卧中铺票价
#define kYWXTag 112         //硬卧下铺票价
#define kRWSTag 113         //软卧上铺票价
#define kRWXTag 114         //软卧下铺票价
#define kGWSTag 115         //高级软卧上铺票价
#define kGWXTag 116         //高级软卧下铺票价

@implementation TrainStationListResultViewController
static int adSuccessCount=0;

@synthesize trainCode = _trainCode;
@synthesize startedStationName = _startedStationName;
@synthesize arrivedStationName = _arrivedStationName;
@synthesize trainDetail = _trainDetail;
@synthesize startDate = _startDate;
@synthesize adview=_adview;

- (void)dealloc {
    [self.trainCode release];
    [self.startedStationName release];
    [self.arrivedStationName release];
    [self.trainDetail release];
    [self.startDate release];
    self.adview.delegate = nil;
    [self.adview release];
    [super dealloc];
}

#pragma mark -
#pragma mark Custom

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

- (void)tipsViewAppear{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.30];
    _tipsView.alpha = 1.0;
    [UIView commitAnimations];
}

- (void)tipsViewDisAppear{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.30];
    _tipsView.alpha = 0.0;
    [UIView commitAnimations];
}

#pragma mark -
#pragma mark View lifecycle

- (void) loadView{
    [super loadView];
    
    self.title = self.trainCode;
    
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
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
    titleView.backgroundColor = [PiosaColorManager secondTitleColor];
    
    UILabel *startedDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 80, 20)];
    startedDateLabel.backgroundColor = [UIColor clearColor];
    startedDateLabel.textColor = [UIColor whiteColor];
    startedDateLabel.font = [UIFont systemFontOfSize:12];
    startedDateLabel.text = self.startDate;
    [titleView addSubview:startedDateLabel];
    [startedDateLabel release];
    
    UILabel *stationLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 120, 25)];
    stationLabel.backgroundColor = [UIColor clearColor];
    stationLabel.textColor = [UIColor whiteColor];
    stationLabel.font = [UIFont boldSystemFontOfSize:14];
    stationLabel.textAlignment = UITextAlignmentCenter;
    stationLabel.text = [NSString stringWithFormat:@"%@ ⇀ %@",self.startedStationName == nil ?[[[self.trainDetail objectForKey:@"dataInfo"] objectAtIndex:0] objectForKey:@"SName"]:self.startedStationName,self.arrivedStationName==nil?[[[self.trainDetail objectForKey:@"dataInfo"] objectAtIndex:([[self.trainDetail objectForKey:@"dataInfo"] count]-1)] objectForKey:@"SName"]:self.arrivedStationName];
    [titleView addSubview:stationLabel];
    [stationLabel release];
    
    UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(235, 5, 80, 20)];
    countLabel.backgroundColor = [UIColor clearColor];
    countLabel.textColor = [UIColor whiteColor];
    countLabel.font = [UIFont boldSystemFontOfSize:12];
    countLabel.textAlignment = UITextAlignmentRight;
    countLabel.text = [NSString stringWithFormat:@"%@个站点",[[self.trainDetail objectForKey:@"pageInfo"] objectForKey:@"totalCount"]];
    [titleView addSubview:countLabel];
    [countLabel release];
    
    [self.view addSubview:titleView];
    [titleView release];
    
    UIScrollView *trainListScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 25, 320, 391)];
    trainListScrollView.contentSize = CGSizeMake(600, 391);
    
    UITableView *trainListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 600, 391) style:UITableViewStylePlain];
    trainListTableView.dataSource = self;
    trainListTableView.delegate = self;
    [trainListScrollView addSubview:trainListTableView];
    [trainListTableView release];
    
    [self.view addSubview:trainListScrollView];
    [trainListScrollView release];
    
    UIView *tipsView = [[UIView alloc] initWithFrame:CGRectMake(80, 250, 160, 80)];
    tipsView.backgroundColor = [PiosaColorManager progressColor];
    tipsView.layer.cornerRadius = 10;
    
    UILabel *tipsArrLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 40)];
    tipsArrLabel.backgroundColor = [UIColor clearColor];
    tipsArrLabel.font = [UIFont systemFontOfSize:60];
    tipsArrLabel.textAlignment = UITextAlignmentCenter;
    tipsArrLabel.textColor = [UIColor whiteColor];
    tipsArrLabel.text = @"↔";
    [tipsView addSubview:tipsArrLabel];
    [tipsArrLabel release];
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 160, 20)];
    tipsLabel.backgroundColor = [UIColor clearColor];
    tipsLabel.font = [UIFont boldSystemFontOfSize:13];
    tipsLabel.textAlignment = UITextAlignmentCenter;
    tipsLabel.textColor = [UIColor whiteColor];
    tipsLabel.text = @"左右划动来查看更多信息";
    [tipsView addSubview:tipsLabel];
    [tipsLabel release];
    
    tipsView.alpha = 0.0;
    [self.view addSubview:tipsView];
    _tipsView = tipsView;
    
    [self performSelector:@selector(tipsViewAppear) withObject:nil afterDelay:0.5];
    [self performSelector:@selector(tipsViewDisAppear) withObject:nil afterDelay:3.0];
    #if showAd
        //广告
        adSuccessCount = 0;
        self.adview = [[WQAdView alloc] init];
        self.adview.delegate = self;
        [self.adview setFrame:CGRectMake(0, 366, 320, 50)];
        self.adview.backgroundColor = [UIColor clearColor];
        [self.adview startWithAdSlotID:kAdslotID AccountKey:kAccountKey InViewController:self.navigationController];
        [self.view addSubview:self.adview];
        [self.adview release];
    #endif
    
//    NSLog(@"subview is %@",[self.view subviews]);
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return [self.trainDetailResponseModel.data count];
    return [[self.trainDetail objectForKey:@"dataInfo"] count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d", indexPath.row];
    
    UILabel * stationName;
    UILabel * costTime;
    UILabel * arrTime;
    UILabel * goTime;
    UILabel * yz;
    UILabel * rz;
    UILabel * rz1;
    UILabel * rz2;
    UILabel * yws;
    UILabel * ywz;
    UILabel * ywx;
    UILabel * rws;
    UILabel * rwx;
    UILabel * gws;
    UILabel * gwx;
    
//    TrainStationData *stationData = (TrainStationData *)[self.trainDetailResponseModel.data objectAtIndex:indexPath.row];
    NSDictionary *stationData = [[self.trainDetail objectForKey:@"dataInfo"] objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        NSString *numberBGPath = [PiosaFileManager ucaiResourcesBoundleCommonFilePath:@"number_bg" inDirectory:@"CommonView"];
        UIImageView * numberImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:numberBGPath]];
        numberImageView.frame = CGRectMake(5, 19, 22, 22);
        [cell.contentView addSubview:numberImageView];
        [numberImageView release];
        
        UILabel * numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 19, 20, 20)];
        numberLabel.backgroundColor = [UIColor clearColor];
        numberLabel.font = [UIFont systemFontOfSize:13];
        numberLabel.textAlignment = UITextAlignmentCenter;
        numberLabel.text = [NSString stringWithFormat:@"%d",indexPath.row+1];
        [cell.contentView addSubview:numberLabel];
        [numberLabel release];
        
        
        UILabel * stationNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 5, 60, 20)];
        stationNameLabel.tag = kStationName;
        stationNameLabel.backgroundColor = [UIColor clearColor];
        stationNameLabel.textColor = [UIColor redColor];
        stationNameLabel.font = [UIFont systemFontOfSize:15];
        stationNameLabel.textAlignment = UITextAlignmentLeft;
        stationName = stationNameLabel;
        [cell.contentView addSubview:stationNameLabel];
        [stationNameLabel release];
        
        UILabel * costTimeLabelLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 30, 40, 20)];
        costTimeLabelLabel.tag = kCostTime;
        costTimeLabelLabel.backgroundColor = [UIColor clearColor];
        costTimeLabelLabel.textColor = [PiosaColorManager fontColor];
        costTimeLabelLabel.font = [UIFont systemFontOfSize:15];
        costTimeLabelLabel.textAlignment = UITextAlignmentCenter;
        costTime = costTimeLabelLabel;
        [cell.contentView addSubview:costTimeLabelLabel];
        [costTimeLabelLabel release];
        
        UILabel * arrTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, 70, 20)];
        arrTimeLabel.tag = kArrTime;
        arrTimeLabel.backgroundColor = [UIColor clearColor];
        arrTimeLabel.font = [UIFont systemFontOfSize:15];
        arrTimeLabel.textAlignment = UITextAlignmentCenter;
        arrTime = arrTimeLabel;
        [cell.contentView addSubview:arrTimeLabel];
        [arrTimeLabel release];
        
        UILabel * goTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 30, 70, 20)];
        goTimeLabel.tag = kGoTime;
        goTimeLabel.backgroundColor = [UIColor clearColor];
        goTimeLabel.textColor = [UIColor grayColor];
        goTimeLabel.font = [UIFont systemFontOfSize:15];
        goTimeLabel.textAlignment = UITextAlignmentCenter;
        goTime = goTimeLabel;
        [cell.contentView addSubview:goTimeLabel];
        [goTimeLabel release];
        
        UILabel * yzLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 5, 40, 20)];
        yzLabel.tag = kYZTag;
        yzLabel.backgroundColor = [UIColor clearColor];
        yzLabel.font = [UIFont systemFontOfSize:15];
        yzLabel.textAlignment = UITextAlignmentCenter;
        yz = yzLabel;
        [cell.contentView addSubview:yzLabel];
        [yzLabel release];
        
        UILabel * rzLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 30, 40, 20)];
        rzLabel.tag = kRZTag;
        rzLabel.backgroundColor = [UIColor clearColor];
        rzLabel.textColor = [UIColor grayColor];
        rzLabel.font = [UIFont systemFontOfSize:15];
        rzLabel.textAlignment = UITextAlignmentCenter;
        rz = rzLabel;
        [cell.contentView addSubview:rzLabel];
        [rzLabel release];
        
        UILabel * rz1Label = [[UILabel alloc] initWithFrame:CGRectMake(205, 5, 70, 20)];
        rz1Label.tag = kRZ1Tag;
        rz1Label.backgroundColor = [UIColor clearColor];
        rz1Label.font = [UIFont systemFontOfSize:15];
        rz1Label.textAlignment = UITextAlignmentCenter;
        rz1 = rz1Label;
        [cell.contentView addSubview:rz1Label];
        [rz1Label release];
        
        UILabel * rz2Label = [[UILabel alloc] initWithFrame:CGRectMake(205, 30, 70, 20)];
        rz2Label.tag = kRZ2Tag;
        rz2Label.backgroundColor = [UIColor clearColor];
        rz2Label.textColor = [UIColor grayColor];
        rz2Label.font = [UIFont systemFontOfSize:15];
        rz2Label.textAlignment = UITextAlignmentCenter;
        rz2 = rz2Label;
        [cell.contentView addSubview:rz2Label];
        [rz2Label release];
        
        UILabel * ywsLabel = [[UILabel alloc] initWithFrame:CGRectMake(280, 5, 45, 40)];
        ywsLabel.tag = kYWSTag;
        ywsLabel.backgroundColor = [UIColor clearColor];
        ywsLabel.font = [UIFont systemFontOfSize:15];
        ywsLabel.textAlignment = UITextAlignmentCenter;
        yws = ywsLabel;
        [cell.contentView addSubview:ywsLabel];
        [ywsLabel release];
        
        UILabel * ywzLabel = [[UILabel alloc] initWithFrame:CGRectMake(327, 5, 45, 40)];
        ywzLabel.tag = kYWZTag;
        ywzLabel.backgroundColor = [UIColor clearColor];
        ywzLabel.font = [UIFont systemFontOfSize:15];
        ywzLabel.textAlignment = UITextAlignmentCenter;
        ywz = ywzLabel;
        [cell.contentView addSubview:ywzLabel];
        [ywzLabel release];
        
        UILabel * ywxLabel = [[UILabel alloc] initWithFrame:CGRectMake(374, 5, 45, 40)];
        ywxLabel.tag = kYWXTag;
        ywxLabel.backgroundColor = [UIColor clearColor];
        ywxLabel.font = [UIFont systemFontOfSize:15];
        ywxLabel.textAlignment = UITextAlignmentCenter;
        ywx = ywxLabel;
        [cell.contentView addSubview:ywxLabel];
        [ywxLabel release];
        
        UILabel * rwsLabel = [[UILabel alloc] initWithFrame:CGRectMake(425, 5, 70, 20)];
        rwsLabel.tag = kRWSTag;
        rwsLabel.backgroundColor = [UIColor clearColor];
        rwsLabel.font = [UIFont systemFontOfSize:15];
        rwsLabel.textAlignment = UITextAlignmentCenter;
        rws = rwsLabel;
        [cell.contentView addSubview:rwsLabel];
        [rwsLabel release];
        
        UILabel * rwxLabel = [[UILabel alloc] initWithFrame:CGRectMake(425, 30, 70, 20)];
        rwxLabel.tag = kRWXTag;
        rwxLabel.backgroundColor = [UIColor clearColor];
        rwxLabel.textColor = [UIColor grayColor];
        rwxLabel.font = [UIFont systemFontOfSize:15];
        rwxLabel.textAlignment = UITextAlignmentCenter;
        rwx = rwxLabel;
        [cell.contentView addSubview:rwxLabel];
        [rwxLabel release];
        
        UILabel * gwsLabel = [[UILabel alloc] initWithFrame:CGRectMake(490, 5, 100, 20)];
        gwsLabel.tag = kGWSTag;
        gwsLabel.backgroundColor = [UIColor clearColor];
        gwsLabel.font = [UIFont systemFontOfSize:15];
        gwsLabel.textAlignment = UITextAlignmentCenter;
        gws = gwsLabel;
        [cell.contentView addSubview:gwsLabel];
        [gwsLabel release];
        
        UILabel * gwxLabel = [[UILabel alloc] initWithFrame:CGRectMake(490, 30, 100, 20)];
        gwxLabel.tag = kGWXTag;
        gwxLabel.backgroundColor = [UIColor clearColor];
        gwxLabel.textColor = [UIColor grayColor];
        gwxLabel.font = [UIFont systemFontOfSize:15];
        gwxLabel.textAlignment = UITextAlignmentCenter;
        gwx = gwxLabel;
        [cell.contentView addSubview:gwxLabel];
        [gwxLabel release];
        
    } else {
        
        stationName = (UILabel *)[cell.contentView viewWithTag:kStationName];
        costTime = (UILabel *)[cell.contentView viewWithTag:kCostTime];
        arrTime = (UILabel *)[cell.contentView viewWithTag:kArrTime];
        goTime = (UILabel *)[cell.contentView viewWithTag:kGoTime];

        yz = (UILabel *)[cell.contentView viewWithTag:kYZTag];
        rz = (UILabel *)[cell.contentView viewWithTag:kRZTag];
        rz1 = (UILabel *)[cell.contentView viewWithTag:kRZ1Tag];
        rz2 = (UILabel *)[cell.contentView viewWithTag:kRZ2Tag];
        yws = (UILabel *)[cell.contentView viewWithTag:kYWSTag];
        ywz = (UILabel *)[cell.contentView viewWithTag:kYWZTag];
        ywx = (UILabel *)[cell.contentView viewWithTag:kYWXTag];
        rws = (UILabel *)[cell.contentView viewWithTag:kRWSTag];
        rwx = (UILabel *)[cell.contentView viewWithTag:kRWXTag];
        gws = (UILabel *)[cell.contentView viewWithTag:kGWSTag];
        gwx = (UILabel *)[cell.contentView viewWithTag:kGWXTag];
    }
    
//    stationName.text = stationData.SName;
//    costTime.text = stationData.CostTime;
//    arrTime.text = stationData.ArrTime;
//    goTime.text = stationData.GoTime;
//    yz.text = stationData.YZ;
//    rz.text = stationData.RZ;
//    rz1.text = stationData.RZ1;
//    rz2.text = stationData.RZ2;
//    yws.text = stationData.YWS;
//    ywz.text = stationData.YWZ;
//    ywx.text = stationData.YWX;
//    rws.text = stationData.RWS;
//    rwx.text = stationData.RWX;
//    gws.text = stationData.GWS;
//    gwx.text = stationData.GWX;
    stationName.text = [stationData objectForKey:@"SName"];
    costTime.text = [stationData objectForKey:@"CostTime"];
    arrTime.text = [stationData objectForKey:@"ArrTime"];
    goTime.text = [stationData objectForKey:@"GoTime"];
    yz.text = [CommonTools checkPrice:[stationData objectForKey:@"YZ"]];
    rz.text = [CommonTools checkPrice:[stationData objectForKey:@"RZ"]];
    rz1.text = [CommonTools checkPrice:[stationData objectForKey:@"RZ1"]];
    rz2.text = [CommonTools checkPrice:[stationData objectForKey:@"RZ2"]];
    yws.text = [CommonTools checkPrice:[stationData objectForKey:@"YWS"]];
    ywz.text = [CommonTools checkPrice:[stationData objectForKey:@"YWX"]];
    ywx.text = [CommonTools checkPrice:[stationData objectForKey:@"YWS"]];
    rws.text = [CommonTools checkPrice:[stationData objectForKey:@"RWS"]];
    rwx.text = [CommonTools checkPrice:[stationData objectForKey:@"RWX"]];
    gws.text = [CommonTools checkPrice:[stationData objectForKey:@"GWS"]];
    gwx.text = [CommonTools checkPrice:[stationData objectForKey:@"GWX"]];
    
    
    if ((indexPath.row+1)%2 == 0) {
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [PiosaColorManager tableViewPlainSepColor];
        cell.backgroundView = bgView;
        [bgView release];
    }  else  {
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor clearColor];
        cell.backgroundView = bgView;
        [bgView release];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIView* myView = [[[UIView alloc] init] autorelease];
	myView.backgroundColor = [PiosaColorManager thirdTitleColor];
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 600, 40)];
	titleLabel.textColor=[UIColor whiteColor];
	titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.numberOfLines = 2;
    titleLabel.text = @"车站名称    到达时间    硬座    一等软座    硬卧    硬卧    硬卧    软卧上铺  高级软卧上铺\n所需时间    发车时间    软座    二等软座    上铺    中铺    下铺    软卧下铺  高级软卧下铺";
	[myView addSubview:titleLabel];
	[titleLabel release];
	return myView;
}

#pragma mark -
#pragma mark Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
	return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
	if ([[[self.trainDetail objectForKey:@"pageInfo"] objectForKey:@"totalCount"] intValue]<=6) {
		UIView *footer = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)] autorelease];
		footer.backgroundColor = [UIColor clearColor];
		return footer;
	} else {
		return nil;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [hud removeFromSuperview];
    [hud release];
	hud = nil;
}

#pragma mark- WQAdviewDelegate mark
//广告视图获取广告成功
- (void)onWQAdReceived:(WQAdView *)adview{
    adSuccessCount++;
    if (adSuccessCount==1) {
        self.adview.backgroundColor = [UIColor whiteColor];
        UIScrollView *scrollView = [[self.view subviews] objectAtIndex:1];
        UITableView *tableView = [[scrollView subviews] objectAtIndex:0];
        tableView.frame = CGRectMake(0, 0, 600, 341);
        scrollView.contentSize = CGSizeMake(600, 341);
        CGRect scrollViewFrame = scrollView.frame;
        scrollViewFrame.size.width = 320;
        scrollViewFrame.size.height -= 50;
        scrollView.frame = scrollViewFrame;
    }
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
