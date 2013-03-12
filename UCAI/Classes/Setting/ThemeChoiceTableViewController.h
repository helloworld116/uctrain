//
//  ThemeChoiceTableViewController.h
//  UCAI
//
//  Created by  on 12-3-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeChoiceTableViewController : UITableViewController<UIActionSheetDelegate>

-(void)updateTheme:(NSNotification*)notif;

@property(nonatomic,copy) NSArray * themePreviewNameArray;
@property(nonatomic,copy) NSArray * themeNameArray;
@property(nonatomic,copy) NSArray * themeArray;

@end
