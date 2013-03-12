//
//  TrainSearchViewController.h
//  UCAI
//
//  Created by  on 12-1-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface TrainSearchViewController : UIViewController<UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>{
    @private
    MBProgressHUD *_hud;
}

@property(nonatomic, retain) UITableView * trainSearchTableView;

@property(nonatomic, retain) UILabel *startCityLabel;
@property(nonatomic, retain) UILabel *arrivalCityLabel;
@property(nonatomic, retain) UILabel *startedDateLabel;

@property(nonatomic, retain) UIToolbar *dateBar;
@property(nonatomic, retain) UIDatePicker *datePicker;

@property(nonatomic, retain) NSString* tmpUrl;

@end
