//
//  WeatherSearchViewController.h
//  UCAI
//
//  Created by  on 11-12-31.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface TrainNumberSearchViewController : UIViewController<UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,MBProgressHUDDelegate>{
    @private
    MBProgressHUD *_hud;
}

@property(nonatomic,retain) UITableView *weatherCityTableView;
@property(nonatomic,retain) UILabel *cityNameLabel;
@property(nonatomic,copy) NSString *cityLat; //纬度
@property(nonatomic,copy) NSString *cityLng; //经度
@property(nonatomic,copy) NSString *provinceName; //省份名称

@property(nonatomic,copy) NSString *lineCode;//车次编号
@property(nonatomic,retain) UITextField *txtLineCode;

@end
