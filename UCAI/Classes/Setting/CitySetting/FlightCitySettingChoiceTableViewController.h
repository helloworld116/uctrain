//
//  FlightCitySettingChoiceTableViewController.h
//  UCAI
//
//  Created by  on 12-2-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlightCitySettingChoiceTableViewController : UITableViewController<UISearchDisplayDelegate,UISearchBarDelegate>{
    NSUInteger _cityType;//城市类型：1-出发城市；2-目的城市
}

@property (nonatomic, retain) NSDictionary *citys;
@property (nonatomic, retain) NSMutableDictionary *filteredCitys;
@property (nonatomic, retain) NSMutableArray *keys;
@property (nonatomic, retain) NSMutableArray *filteredKeys;

@property (nonatomic, retain) UISearchDisplayController *searchController;

- (FlightCitySettingChoiceTableViewController *)initWithCityType:(NSUInteger)cityType andStyle:(UITableViewStyle) tableViewStyle;

@end
