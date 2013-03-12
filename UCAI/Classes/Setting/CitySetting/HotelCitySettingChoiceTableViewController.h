//
//  HotelCitySettingChoiceTableViewController.h
//  UCAI
//
//  Created by  on 12-2-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotelCitySettingChoiceTableViewController : UITableViewController<UISearchDisplayDelegate,UISearchBarDelegate>

@property (nonatomic, retain) NSDictionary *citys;
@property (nonatomic, retain) NSMutableDictionary *filteredCitys;
@property (nonatomic, retain) NSMutableArray *keys;
@property (nonatomic, retain) NSMutableArray *filteredKeys;

@property (nonatomic, retain) UISearchDisplayController *searchController;

@end
