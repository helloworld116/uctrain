//
//  RootViewController1.h
//  UCAI
//
//  Created by apple on 13-1-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrainSearchViewController.h"
#import "StationViewController.h"
#import "TrainNumberSearchViewController.h"
#import "WQAdView.h"

@interface RootViewController : UIViewController<UIScrollViewDelegate,WQAdViewDelegate>
@property (retain, nonatomic) IBOutlet UISegmentedControl *segment;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;

@property (retain, nonatomic) TrainSearchViewController *trainSearchViewController;
@property (retain, nonatomic) TrainNumberSearchViewController *weatherSearchViewController;
@property (retain, nonatomic) StationViewController *stationViewController;
@property (retain, nonatomic) WQAdView *adview;
@end
