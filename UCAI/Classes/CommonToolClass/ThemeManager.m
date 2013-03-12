//
//  ThemeManager.m
//  UCAI
//
//  Created by  on 12-3-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ThemeManager.h"
#import "PiosaFileManager.h"
#import "StaticConf.h"

@implementation ThemeManager

static ThemeManager *instance=nil;

@synthesize barColor = _barColor;
@synthesize tableViewPlainHeaderColor = _tableViewPlainHeaderColor;
@synthesize tableViewPlainSepColor = _tableViewPlainSepColor;
@synthesize fontColor = _fontColor;
@synthesize themeColor = _themeColor;
@synthesize secondTitleColor = _secondTitleColor;
@synthesize thirdTitleColor = _thirdTitleColor;
@synthesize bigMethodFontNormalColor = _bigMethodFontNormalColor;
@synthesize bigMethodFontPressedColor = _bigMethodFontPressedColor;
@synthesize progressColor = _progressColor;

-(id)init
{
	if (self=[super init]) {
        NSMutableDictionary *loginDict = [PiosaFileManager applicationPlistFromFile:UCAI_THEME_FILE_NAME];
        
        if (!loginDict) {
            //当还没有主题存储文件存在时
            [self setGreen];
            loginDict = [NSMutableDictionary dictionary];
            [loginDict setValue:[NSNumber numberWithInt:UCAIThemeGreen] forKey:@"UCAITheme"];
            [PiosaFileManager writeApplicationPlist:loginDict toFile:UCAI_THEME_FILE_NAME];
        } else {
            NSNumber * theme = (NSNumber *)[loginDict objectForKey:@"UCAITheme"];
            switch ([theme intValue]) {
                case UCAIThemeGreen:
                    [self setGreen];
                    break;
                case UCAIThemeBlue:
                    [self setBlue];
                    break;
                case UCAIThemeRed:
                    [self setRed];
                    break;
                case UCAIThemeBlack:
                    [self setBlack];
                    break;
                    
            }
        }
    }
    
    return self;
}

- (void)dealloc{
    [_barColor release];
    [_tableViewPlainHeaderColor release];
    [_tableViewPlainSepColor release];
    [_fontColor release];
    [_themeColor release];
    [_secondTitleColor release];
    [_thirdTitleColor release];
    [_bigMethodFontNormalColor release];
    [_bigMethodFontPressedColor release];
    [_progressColor release];
    [super dealloc];
}

+(ThemeManager *)shareThemeManager{
    @synchronized(self){
        if (instance == nil) {
            instance=[[ThemeManager alloc] init];
        }
    }
    return instance;
}

//设置绿色主题操作
-(void)setGreen{
    _currentTheme = UCAIThemeGreen;
    _currentThemeFolderName = @"UCAIThemeGreen";
    _barColor = [[UIColor colorWithRed:0.17 green:0.57 blue:0.00 alpha:0.5] retain];
    _tableViewPlainHeaderColor = [[UIColor colorWithRed:0.0 green:0.7 blue:0.0 alpha:0.7] retain];
    _tableViewPlainSepColor = [[UIColor colorWithRed:0.071 green:0.82 blue:0.071 alpha:0.1] retain];
    _fontColor = [[UIColor colorWithRed:0.10 green:0.50 blue:0.00 alpha:1.0] retain];
    _themeColor = [[UIColor greenColor] retain];
    _secondTitleColor = [[UIColor colorWithRed:0.20 green:0.357 blue:0.20 alpha:1.0] retain];
    _thirdTitleColor = [[UIColor colorWithRed:0.20 green:0.357 blue:0.20 alpha:0.7] retain];
    _bigMethodFontNormalColor = [UIColor whiteColor];
    _bigMethodFontPressedColor = [UIColor whiteColor];
    _progressColor = [[UIColor colorWithRed:0.10 green:0.50 blue:0.00 alpha:0.8] retain];
}

//设置蓝色主题操作
-(void)setBlue{
    _currentTheme = UCAIThemeBlue;
    _currentThemeFolderName = @"UCAIThemeBlue";
    _barColor = [[UIColor colorWithRed:0.05 green:0.56 blue:0.81 alpha:0.5] retain];
    _tableViewPlainHeaderColor = [[UIColor colorWithRed:0.06 green:0.62 blue:0.87 alpha:0.7] retain];
    _tableViewPlainSepColor = [[UIColor colorWithRed:0.06 green:0.62 blue:0.87 alpha:0.1] retain];
    _fontColor = [[UIColor colorWithRed:0.05 green:0.42 blue:0.69 alpha:1.0] retain];
    _themeColor = [[UIColor blueColor] retain];
    _secondTitleColor = [[UIColor colorWithRed:0.06 green:0.62 blue:0.87 alpha:1.0] retain];
    _thirdTitleColor = [[UIColor colorWithRed:0.06 green:0.62 blue:0.87 alpha:0.7] retain];
    _bigMethodFontNormalColor = [UIColor whiteColor];
    _bigMethodFontPressedColor = [UIColor whiteColor];
    _progressColor = [[UIColor colorWithRed:0.07 green:0.58 blue:0.85 alpha:0.8] retain];
}

//设置红色主题操作
-(void)setRed{
    _currentTheme = UCAIThemeRed;
    _currentThemeFolderName = @"UCAIThemeRed";
    _barColor = [[UIColor colorWithRed:0.81 green:0.33 blue:0.08 alpha:0.5] retain];
    _tableViewPlainHeaderColor = [[UIColor colorWithRed:0.85 green:0.40 blue:0.13 alpha:0.7] retain];
    _tableViewPlainSepColor = [[UIColor colorWithRed:0.85 green:0.40 blue:0.13 alpha:0.1] retain];
    _fontColor = [[UIColor colorWithRed:0.57 green:0.09 blue:0.17 alpha:1.0] retain];
    _themeColor = [[UIColor orangeColor] retain];
    _secondTitleColor = [[UIColor colorWithRed:0.85 green:0.40 blue:0.13 alpha:1.0] retain];
    _thirdTitleColor = [[UIColor colorWithRed:0.85 green:0.40 blue:0.13 alpha:0.7] retain];
    _bigMethodFontNormalColor = [UIColor blackColor];
    _bigMethodFontPressedColor = [UIColor whiteColor];
    _progressColor = [[UIColor colorWithRed:0.86 green:0.26 blue:0.06 alpha:0.8] retain];
}

//设置黑色主题操作
-(void)setBlack{
    _currentTheme = UCAIThemeBlack;
    _currentThemeFolderName = @"UCAIThemeBlack";
    _barColor = [[UIColor colorWithRed:0.23 green:0.23 blue:0.23 alpha:0.5] retain];
    _tableViewPlainHeaderColor = [[UIColor colorWithRed:0.27 green:0.27 blue:0.27 alpha:0.7] retain];
    _tableViewPlainSepColor = [[UIColor colorWithRed:0.27 green:0.27 blue:0.27 alpha:0.1] retain];
    _fontColor = [[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0] retain];
    _themeColor = [[UIColor blackColor] retain];
    _secondTitleColor = [[UIColor colorWithRed:0.27 green:0.27 blue:0.27 alpha:1.0] retain];
    _thirdTitleColor = [[UIColor colorWithRed:0.27 green:0.27 blue:0.27 alpha:0.7] retain];
    _bigMethodFontNormalColor = [UIColor blackColor];
    _bigMethodFontPressedColor = [UIColor whiteColor];
    _progressColor = [[UIColor colorWithRed:0.20 green:0.20 blue:0.20 alpha:0.8] retain];
}

-(void)setCurrentTheme:(UCAITheme) ucaiTheme{
    NSMutableDictionary *loginDict = [PiosaFileManager applicationPlistFromFile:UCAI_THEME_FILE_NAME];
    
    switch (ucaiTheme) {
        case UCAIThemeGreen:
            [self setGreen];
            break;
        case UCAIThemeBlue:
            [self setBlue];
            break;
        case UCAIThemeRed:
            [self setRed];
            break;
        case UCAIThemeBlack:
            [self setBlack];
            break;
    }
    
    [loginDict setValue:[NSNumber numberWithInt:_currentTheme] forKey:@"UCAITheme"];
    [PiosaFileManager writeApplicationPlist:loginDict toFile:UCAI_THEME_FILE_NAME];
}

-(UCAITheme)getCurrentTheme{
    return _currentTheme;
}

-(NSString *)currentThemeFolderName{
    return _currentThemeFolderName;
}

@end
