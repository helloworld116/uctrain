//
//  SettingChoiceViewController.h
//  UCAI
//
//  Created by  on 12-1-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingChoiceViewController : UIViewController<UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain) UIImageView *bgImageView;
@property(nonatomic,retain) UIButton * phoneButton;
@property(nonatomic,retain) UITableView *choiceTableView;

@property(nonatomic,retain) UILabel *hotelDefaultCityNameLabel;
@property(nonatomic,retain) UILabel *flightDefaultStartedCityNameLabel;
@property(nonatomic,retain) UILabel *flightDefaultArrivedCityNameLabel;
@property(nonatomic,retain) UILabel *trainDefaultStartedCityNameLabel;
@property(nonatomic,retain) UILabel *trainDefaultArrivedCityNameLabel;
@property(nonatomic,retain) UILabel *weatherDefaultCityNameLabel;

@end
