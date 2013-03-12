//
//  StationViewController.h
//  UCAI
//
//  Created by apple on 13-1-5.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface StationViewController : UIViewController<UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate>{
@private
    MBProgressHUD *_hud;
}

@property(nonatomic,retain) UITableView *cityTableView;

@property(nonatomic,copy) NSString *stationName;//车站名称
@property(nonatomic,retain) UILabel *lblStationName;

@property(nonatomic,copy) NSString *stationType;//车站类型
@property(nonatomic,retain) UILabel *lblStationType;


@end
