//
//  PiosaFileManager.h
//  UCAI
//
//  Created by  on 12-3-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define UCAI_RESOURCES_BUNDLE_NAME @"UCAIResources.bundle"
#define UCAI_RESOURCES_BUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:UCAI_RESOURCES_BUNDLE_NAME]
#define UCAI_RESOURCES_BUNDLE [NSBundle bundleWithPath:UCAI_RESOURCES_BUNDLE_PATH]
#define UCAI_RESOURCES_BUNDLE_RESOURCE_PATH [UCAI_RESOURCES_BUNDLE resourcePath]

#import <Foundation/Foundation.h>
#import "ThemeManager.h"

@interface PiosaFileManager : NSObject

+ (BOOL)writeApplicationPlist:(id)plist toFile:(NSString *)fileName;

+ (BOOL)writeApplicationData:(NSData *)data toFile:(NSString *)fileName;

+ (id)applicationPlistFromFile:(NSString *)fileName;

+ (NSData *)applicationDataFromFile:(NSString *)fileName;

//获取主题文件夹(Images/Theme)下的图片文件路径
+ (NSString *)ucaiResourcesBoundleThemeFilePath:(NSString *)filename inDirectory:(NSString *)subpath;

//获取公共文件夹(Images/Common)下的图片文件路径
+ (NSString *)ucaiResourcesBoundleCommonFilePath:(NSString *)filename inDirectory:(NSString *)subpath;

//获取字典文件夹(Dictionary)下的文件路径
+ (NSString *)ucaiResourcesBoundleDicFilePath:(NSString *)filename inDirectory:(NSString *)subpath;

@end