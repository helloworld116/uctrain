//
//  ThemeChoiceTableViewController.m
//  UCAI
//
//  Created by  on 12-3-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ThemeChoiceTableViewController.h"
#import "ThemeManager.h"
#import "PiosaFileManager.h"

#define kCellThemeImageViewTag 101
#define kCellThemeNameLabelTag 102

@implementation ThemeChoiceTableViewController

@synthesize themePreviewNameArray = _themePreviewNameArray;
@synthesize themeNameArray = _themeNameArray;
@synthesize themeArray = _themeArray;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(updateTheme:) 
                                                     name:kThemeDidChangeNotification 
                                                   object:nil];
        
        self.themePreviewNameArray = [NSArray arrayWithObjects:@"themeGreenPreview",@"themeBluePreview",@"themeRedPreview",@"themeBlackPreview" ,nil];
        self.themeNameArray = [NSArray arrayWithObjects:@"自然绿",@"天空蓝",@"通透红",@"沉淀黑", nil];
    }
    return self;
}

- (void)dealloc{
    [self.themePreviewNameArray release];
    [self.themeNameArray release];
    [self.themeArray release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"主题选择";
	
	[self updateTheme:nil];
 
}

#pragma mark -
#pragma mark Custom

-(void)updateTheme:(NSNotification*)notif
{
    //返回按钮
    NSString *backButtonNormalPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"backButton_normal" inDirectory:@"CommonView/NavigationItem"];
    NSString *backButtonHighlightedPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"backButton_highlighted" inDirectory:@"CommonView/NavigationItem"];
    UIButton * backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    backButton.tag = 101;
    [backButton setBackgroundImage:[UIImage imageNamed:backButtonNormalPath] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:backButtonHighlightedPath] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backOrHome:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    [backBarButtonItem release];
    [backButton release];
    
    //主页按钮
    NSString *homeButtonNormalPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"homeButton_normal" inDirectory:@"CommonView/NavigationItem"];
    NSString *homeButtonHighlightedPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"homeButton_highlighted" inDirectory:@"CommonView/NavigationItem"];
    UIButton * homeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    homeButton.tag = 102;
    [homeButton setBackgroundImage:[UIImage imageNamed:homeButtonNormalPath] forState:UIControlStateNormal];
    [homeButton setBackgroundImage:[UIImage imageNamed:homeButtonHighlightedPath] forState:UIControlStateHighlighted];
    [homeButton addTarget:self action:@selector(backOrHome:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *homeBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:homeButton];
    self.navigationItem.rightBarButtonItem = homeBarButtonItem;
    [homeBarButtonItem release];
    [homeButton release];
    
	//设置背景图片
	NSString *bgPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"background" inDirectory:@"CommonView"];
	UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:bgPath]];
    bgImageView.frame = CGRectMake(0, 0, 320, 416);
	self.tableView.backgroundView=bgImageView;
	[bgImageView release];
    
    [self.tableView reloadData];
}

- (void)phoneCall{
    if ([[UIApplication  sharedApplication] canOpenURL:[NSURL  URLWithString:@"tel://4006840060"]]) {
        UIActionSheet * phoneActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拨打电话40068 40060" otherButtonTitles:nil, nil];
        phoneActionSheet.delegate = self;
        [phoneActionSheet showInView:[UIApplication sharedApplication].keyWindow];
		[phoneActionSheet release];
    }
}

- (void)backOrHome:(UIButton *) button
{
    switch (button.tag) {
        case 101:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case 102:
            [self.navigationController popToRootViewControllerAnimated:YES];
            break;
    }
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 6, 126, 32)];
        imageView.tag = kCellThemeImageViewTag;
        [cell.contentView addSubview:imageView];
        [imageView release];
        
        UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(146, 6, 100, 32)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.tag = kCellThemeNameLabelTag;
        [cell.contentView addSubview:nameLabel];
        [nameLabel release];
    }
    
    //设置主题预览图片
    NSString * themePreviewPath = [PiosaFileManager ucaiResourcesBoundleCommonFilePath:[self.themePreviewNameArray objectAtIndex:indexPath.row] inDirectory:@"Setting/ThemeChoice"];
    UIImageView * imageTempView = (UIImageView *)[cell.contentView viewWithTag:kCellThemeImageViewTag];
    imageTempView.image = [UIImage imageNamed:themePreviewPath];
    
    //设置主题名称
    UILabel * nameTempLabel = (UILabel *)[cell.contentView viewWithTag:kCellThemeNameLabelTag];
    nameTempLabel.text = [self.themeNameArray objectAtIndex:indexPath.row];
    
    //设置主题选中状态
    if ([[ThemeManager shareThemeManager] getCurrentTheme] == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if ([self.tableView numberOfRowsInSection:indexPath.section] == 1) {
        NSString *tableViewCellSingleNormalPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"tableViewCell_single_normal" inDirectory:@"CommonView/TableViewCell"];
        NSString *tableViewCellSingleHighlightedPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"tableViewCell_single_highlighted" inDirectory:@"CommonView/TableViewCell"];
        cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:tableViewCellSingleNormalPath]] autorelease];
        cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:tableViewCellSingleHighlightedPath]] autorelease];
    } else {
        if (indexPath.row == 0) {
            NSString *tableViewCellTopNormalPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"tableViewCell_top_normal" inDirectory:@"CommonView/TableViewCell"];
            NSString *tableViewCellTopHighlightedPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"tableViewCell_top_highlighted" inDirectory:@"CommonView/TableViewCell"];
            cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:tableViewCellTopNormalPath]] autorelease];
            cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:tableViewCellTopHighlightedPath]] autorelease];
        } else if(indexPath.row == [self.tableView numberOfRowsInSection:indexPath.section]-1){
            NSString *tableViewCellBottomNormalPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"tableViewCell_bottom_normal" inDirectory:@"CommonView/TableViewCell"];
            NSString *tableViewCellBottomHighlightedPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"tableViewCell_bottom_highlighted" inDirectory:@"CommonView/TableViewCell"];
            cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:tableViewCellBottomNormalPath]] autorelease];
            cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:tableViewCellBottomHighlightedPath]] autorelease];
        } else {
            NSString *tableViewCellCenterNormalPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"tableViewCell_center_normal" inDirectory:@"CommonView/TableViewCell"];
            NSString *tableViewCellCenterHighlightedPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"tableViewCell_center_highlighted" inDirectory:@"CommonView/TableViewCell"];
            cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:tableViewCellCenterNormalPath]] autorelease];
            cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:tableViewCellCenterHighlightedPath]] autorelease];
        }
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [[ThemeManager shareThemeManager] setCurrentTheme:UCAIThemeGreen];
            break;
        case 1:
            [[ThemeManager shareThemeManager] setCurrentTheme:UCAIThemeBlue];
            break;
        case 2:
            [[ThemeManager shareThemeManager] setCurrentTheme:UCAIThemeRed];
            break;
        case 3:
            [[ThemeManager shareThemeManager] setCurrentTheme:UCAIThemeBlack];
            break;
    }
    
    [NSThread sleepForTimeInterval:0.2];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kThemeDidChangeNotification 
                                                        object:nil 
                                                      userInfo:nil];
    
}

@end
