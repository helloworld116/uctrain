//
//  ThemeManager.h
//  UCAI
//
//  Created by  on 12-3-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kThemeDidChangeNotification @"ThemeDidChangeNotification"

typedef enum {
    UCAIThemeGreen,
    UCAIThemeBlue,
    UCAIThemeRed,
    UCAIThemeBlack
} UCAITheme;

@interface ThemeManager : NSObject{
    UCAITheme _currentTheme;
    NSString * _currentThemeFolderName;
}

@property(nonatomic,readonly) UIColor * barColor;
@property(nonatomic,readonly) UIColor * tableViewPlainHeaderColor;
@property(nonatomic,readonly) UIColor * tableViewPlainSepColor;
@property(nonatomic,readonly) UIColor * fontColor;
@property(nonatomic,readonly) UIColor * themeColor;
@property(nonatomic,readonly) UIColor * secondTitleColor;
@property(nonatomic,readonly) UIColor * thirdTitleColor;
@property(nonatomic,readonly) UIColor * bigMethodFontNormalColor;
@property(nonatomic,readonly) UIColor * bigMethodFontPressedColor;
@property(nonatomic,readonly) UIColor * progressColor;

+(ThemeManager *)shareThemeManager;

//设置当前主题
-(void)setCurrentTheme:(UCAITheme) ucaiTheme;

//设置绿色主题操作
-(void)setGreen;

//设置蓝色主题操作
-(void)setBlue;

//设置红色主题操作
-(void)setRed;

//设置黑色主题操作
-(void)setBlack;

//获取当前主题
-(UCAITheme)getCurrentTheme;

//获取当前主题文件夹名称
-(NSString *)currentThemeFolderName;

@end
