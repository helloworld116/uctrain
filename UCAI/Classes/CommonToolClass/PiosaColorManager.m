//
//  PiosaColorManager.m
//  UCAI
//
//  Created by  on 12-3-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PiosaColorManager.h"
#import "ThemeManager.h"

@implementation PiosaColorManager

//导航栏、工具栏的颜色
+ (UIColor *)barColor{
    return [ThemeManager shareThemeManager].barColor;
}

//列表头部主题色
+ (UIColor *)tableViewPlainHeaderColor{
    return [ThemeManager shareThemeManager].tableViewPlainHeaderColor;
}

//列表行分隔色
+ (UIColor *)tableViewPlainSepColor{
    return [ThemeManager shareThemeManager].tableViewPlainSepColor;
}

//字体色
+ (UIColor *)fontColor{
    return [ThemeManager shareThemeManager].fontColor;
}

//主题色
+ (UIColor *)themeColor{
    return [ThemeManager shareThemeManager].themeColor;
}

//第二标题色
+ (UIColor *)secondTitleColor{
    return [ThemeManager shareThemeManager].secondTitleColor;
}

//第三标题色
+ (UIColor *)thirdTitleColor{
    return [ThemeManager shareThemeManager].thirdTitleColor;
}

//大按钮字普通色
+ (UIColor *)bigMethodFontNormalColor{
    return [ThemeManager shareThemeManager].bigMethodFontNormalColor;
}

//大按钮字按下色
+ (UIColor *)bigMethodFontPressedColor{
    return [ThemeManager shareThemeManager].bigMethodFontPressedColor;
}

//进程等待色
+ (UIColor *)progressColor{
    return [ThemeManager shareThemeManager].progressColor;
}

@end
