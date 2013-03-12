//
//  StationCityChoiceViewController.h
//  UCAI
//
//  Created by apple on 13-1-6.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StationViewController.h"

@interface StationCityChoiceViewController : UITableViewController<UISearchDisplayDelegate,UISearchBarDelegate>{
}

@property (nonatomic, retain) NSDictionary *citys;
@property (nonatomic, retain) NSMutableDictionary *filteredCitys;
@property (nonatomic, retain) NSMutableArray *keys;
@property (nonatomic, retain) NSMutableArray *filteredKeys;

@property (nonatomic, retain) UISearchDisplayController *searchController;
@property (nonatomic, retain) StationViewController *stationViewContrller;
@end
