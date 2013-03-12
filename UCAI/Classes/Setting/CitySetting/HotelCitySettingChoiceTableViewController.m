//
//  HotelCitySettingChoiceTableViewController.m
//  UCAI
//
//  Created by  on 12-2-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HotelCitySettingChoiceTableViewController.h"
#import "NSString-NumericCompare.h"

@implementation HotelCitySettingChoiceTableViewController

@synthesize citys = _citys;
@synthesize filteredCitys = _filteredCitys;
@synthesize keys = _keys;
@synthesize filteredKeys = _filteredKeys;
@synthesize searchController = _searchController;

- (void)dealloc {
	[self.citys release];
    [self.filteredCitys release];
	[self.keys release];
    [self.filteredKeys release];
    [self.searchController release];
    [super dealloc];
}

#pragma mark -
#pragma mark Custom

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

#pragma mark -
#pragma mark View lifecycle


- (void)loadView {
    [super loadView];
	
	self.title = @"选择酒店默认入住城市";
    
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
    
    NSString *path = [PiosaFileManager ucaiResourcesBoundleDicFilePath:@"hotelCity" inDirectory:nil];
	NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
	self.citys = dict;
	[dict release];
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithObjects:UITableViewIndexSearch, nil];
	NSArray *array = [[[self.citys allKeys] sortedArrayUsingSelector:@selector(compare:)] sortedArrayUsingSelector:@selector(psuedoNumericCompare:)];
    [tempArray addObjectsFromArray:array];
	self.keys = tempArray;
    [tempArray release];
    
    self.filteredCitys = [NSMutableDictionary dictionaryWithDictionary:self.citys];
    [self.filteredCitys removeAllObjects];
    
    self.filteredKeys = [NSMutableArray arrayWithCapacity:[self.keys count]];
    
    //搜索栏
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    searchBar.tintColor = [PiosaColorManager themeColor];
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    searchBar.delegate = self;
    self.tableView.tableHeaderView = searchBar;
    [searchBar release];
    
    //搜索展示控制器
    UISearchDisplayController *searchController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    searchController.delegate = self;
    searchController.searchResultsDataSource = self;
    searchController.searchResultsDelegate = self;
    [self.searchDisplayController setActive:NO];
    self.searchController = searchController;
    
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointMake(0.0, 44.0) animated:NO];
}

- (void)viewDidUnload {
    self.citys = nil;
    self.filteredCitys = nil;
	self.keys = nil;
    self.filteredKeys = nil;
    self.searchController = nil;
}

#pragma mark -
#pragma mark UISearchBarDelegate Delegate Methods

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [self.searchDisplayController setActive:YES animated:YES];
}


#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{
    [self.tableView setContentOffset:CGPointMake(0.0, 44.0) animated:YES];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self.filteredCitys removeAllObjects];
    [self.filteredKeys removeAllObjects];
    
    for (NSString * keyString in self.keys) {
        NSArray *citys = [self.citys objectForKey:keyString];
        
        for (NSArray *city in citys) {
            if ([[city objectAtIndex:0] compare:searchString options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchString length])] == NSOrderedSame
                || [[city objectAtIndex:2] compare:searchString options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchString length])] == NSOrderedSame)
			{
                NSUInteger findResult = [self.filteredKeys indexOfObject:keyString];
                
                if (findResult == NSNotFound) {
                    //过滤的key数组中没有此key
                    [self.filteredKeys addObject:keyString];
                    NSMutableArray * cityFind = [NSMutableArray arrayWithObject:city];
                    [self.filteredCitys setObject:cityFind forKey:keyString];
                }else{
                    NSMutableArray *exitCitys = [self.filteredCitys objectForKey:keyString];
                    [exitCitys addObject:city];
                    [self.filteredCitys setObject:exitCitys forKey:keyString];
                }
            }
            
        }
    }
    
    return YES;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.searchDisplayController.searchResultsTableView){
        return [self.filteredCitys count];
    }else{
        return [self.keys count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView){
        NSString *key = [self.filteredKeys objectAtIndex:section];
        NSArray *citySection = [self.filteredCitys objectForKey:key];
        return [citySection count];
    }else{
        NSString *key = [self.keys objectAtIndex:section];
        NSArray *citySection = [self.citys objectForKey:key];
        return [citySection count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        cell.textLabel.highlightedTextColor = [PiosaColorManager themeColor];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        NSString *tableViewCellPlainHighlightedPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"tableViewCell_plain_highlighted" inDirectory:@"CommonView/TableViewCell"];
        cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:tableViewCellPlainHighlightedPath]] autorelease];
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView){
        NSString *key = [self.filteredKeys objectAtIndex:indexPath.section];
        NSArray *citySection = [self.filteredCitys objectForKey:key];
        cell.textLabel.text = [[citySection objectAtIndex:indexPath.row] objectAtIndex:0];
    }else{
        NSString *key = [self.keys objectAtIndex:indexPath.section];
        NSArray *citySection = [self.citys objectForKey:key];
        cell.textLabel.text = [[citySection objectAtIndex:indexPath.row] objectAtIndex:0];
    }
    
    
    if ((indexPath.row+1)%2 == 0) {
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [PiosaColorManager tableViewPlainSepColor];
        cell.backgroundView = bgView;
        [bgView release];
    }  else  {
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor clearColor];
        cell.backgroundView = bgView;
        [bgView release];
    }
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (tableView == self.searchDisplayController.searchResultsTableView){
        return nil;
    }else{
        return self.keys;
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    if ([self.keys objectAtIndex:index] == UITableViewIndexSearch) {
        [self.searchDisplayController.searchBar becomeFirstResponder];
        return NSNotFound;
    } else {
        return index;
    }
}

#pragma mark -
#pragma mark Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == self.searchDisplayController.searchResultsTableView){
        return 20;
    } else {
        if (section == 0) {
            return 0;
        } else {
            return 20;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView){
        UIView* myView = [[[UIView alloc] init] autorelease];
        myView.backgroundColor = [PiosaColorManager tableViewPlainHeaderColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 90, 22)];
        titleLabel.textColor=[UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text=[self.filteredKeys objectAtIndex:section];
        [myView addSubview:titleLabel];
        [titleLabel release];
        return myView;
    }else{
        if ([self.keys objectAtIndex:section] == UITableViewIndexSearch) {
            return nil;
        } else {
            UIView* myView = [[[UIView alloc] init] autorelease];
            myView.backgroundColor = [PiosaColorManager tableViewPlainHeaderColor];
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 90, 22)];
            titleLabel.textColor=[UIColor whiteColor];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.text=[self.keys objectAtIndex:section];
            [myView addSubview:titleLabel];
            [titleLabel release];
            return myView;
        }
    }  
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *citySection;
    
    if (tableView == self.searchDisplayController.searchResultsTableView){
        NSString *key = [self.filteredKeys objectAtIndex:indexPath.section];
        citySection = [self.filteredCitys objectForKey:key];
    }else{
        NSString *key = [self.keys objectAtIndex:indexPath.section];
        citySection = [self.citys objectForKey:key];
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:[[citySection objectAtIndex:indexPath.row] objectAtIndex:0] forKey:@"hotelDefaultCityName"];
    [userDefaults setValue:[[citySection objectAtIndex:indexPath.row] objectAtIndex:1] forKey:@"hotelDefaultCityCode"];
	
	NSArray *allControllers = self.navigationController.viewControllers;
	UITableViewController *parent = [allControllers lastObject];
	[parent.tableView reloadData];
	
	[self.navigationController popViewControllerAnimated:YES];
}

@end
