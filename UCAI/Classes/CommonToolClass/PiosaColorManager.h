//
//  PiosaColorManager.h
//  UCAI
//
//  Created by  on 12-3-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PiosaColorManager : NSObject

//导航栏、工具栏的颜色
+ (UIColor *)barColor;

//列表头部主题色
+ (UIColor *)tableViewPlainHeaderColor;

//列表行分隔色
+ (UIColor *)tableViewPlainSepColor;

//字体色
+ (UIColor *)fontColor;

//主题色
+ (UIColor *)themeColor;

//第二标题色
+ (UIColor *)secondTitleColor;

//第三标题色
+ (UIColor *)thirdTitleColor;

//大按钮字普通色
+ (UIColor *)bigMethodFontNormalColor;

//大按钮字按下色
+ (UIColor *)bigMethodFontPressedColor;

//进程等待色
+ (UIColor *)progressColor;
@end
