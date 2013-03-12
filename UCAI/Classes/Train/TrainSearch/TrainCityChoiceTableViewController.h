//
//  TrainCityChoiceTableViewController.h
//  UCAI
//
//  Created by  on 12-1-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrainSearchViewController.h"

@interface TrainCityChoiceTableViewController : UITableViewController<UISearchDisplayDelegate,UISearchBarDelegate>{
    @private
    NSUInteger _cityType;
}

@property (nonatomic, retain) NSDictionary *citys;
@property (nonatomic, retain) NSMutableDictionary *filteredCitys;
@property (nonatomic, retain) NSMutableArray *keys;
@property (nonatomic, retain) NSMutableArray *filteredKeys;

@property (nonatomic, retain) UISearchDisplayController *searchController;

@property (nonatomic, retain) TrainSearchViewController *trainSearchViewController;

//cityType:1-出发城市 2-目的城市
- (TrainCityChoiceTableViewController *)initWithCityType:(NSUInteger) cityType;

@end
