//
//  TrainSearchListResultViewController.h
//  UCAI
//
//  Created by  on 12-1-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "STableViewController.h"
#import "WQAdView.h"
@class TrainSearchResponseModel;

@interface TrainSearchListResultViewController : STableViewController<MBProgressHUDDelegate,WQAdViewDelegate>{
    @private
    MBProgressHUD *_hud;
    NSUInteger _selectedRow;
    
    UIView *_tipsView;
}


@property(nonatomic, copy) NSString *startedCityName;
@property(nonatomic, copy) NSString *arrivedCityName;
@property(nonatomic, copy) NSString *startDate;

@property(nonatomic, retain) NSMutableDictionary *data;
@property(nonatomic, retain) NSMutableArray *trains;
@property(nonatomic) NSInteger currentPage;
@property(nonatomic, retain) NSString *url;
//@property (nonatomic, retain) UITableView *tableView;
@property(nonatomic,retain) WQAdView *adview;
@end
