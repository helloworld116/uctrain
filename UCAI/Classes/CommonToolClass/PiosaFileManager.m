//
//  PiosaFileManager.m
//  UCAI
//
//  Created by  on 12-3-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PiosaFileManager.h"


@implementation PiosaFileManager

+ (BOOL)writeApplicationPlist:(id)plist toFile:(NSString *)fileName {
    NSString *error;
    NSData *pData = [NSPropertyListSerialization dataFromPropertyList:plist format:NSPropertyListBinaryFormat_v1_0 errorDescription:&error];
    if (!pData) {
        NSLog(@"%@", error);
        return NO;
    }
    return ([PiosaFileManager writeApplicationData:pData toFile:(NSString *)fileName]);
}

+ (BOOL)writeApplicationData:(NSData *)data toFile:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
    return ([data writeToFile:appFile atomically:YES]);
}

+ (id)applicationPlistFromFile:(NSString *)fileName {
    NSData *retData;
    NSString *error;
    id retPlist;
    NSPropertyListFormat format;
    
    retData = [PiosaFileManager applicationDataFromFile:fileName];
    if (!retData) {
        NSLog(@"Data file not returned.");
        return nil;
    }
    retPlist = [NSPropertyListSerialization propertyListFromData:retData  mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&error];
    if (!retPlist){
        NSLog(@"Plist not returned, error: %@", error);
    }
    return retPlist;
}

+ (NSData *)applicationDataFromFile:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
    NSData *myData = [[[NSData alloc] initWithContentsOfFile:appFile] autorelease];
    return myData;
}

+ (NSString *)ucaiResourcesBoundleThemeFilePath:(NSString*)filename inDirectory:(NSString *)subpath{
    
    NSString * returnString = nil;
    if (subpath==nil) {
        returnString = [NSString stringWithFormat:@"%@/Images/Theme/%@/%@.png",UCAI_RESOURCES_BUNDLE_NAME,[[ThemeManager shareThemeManager] currentThemeFolderName],filename];
    } else {
        returnString = [NSString stringWithFormat:@"%@/Images/Theme/%@/%@/%@.png",UCAI_RESOURCES_BUNDLE_NAME,[[ThemeManager shareThemeManager] currentThemeFolderName],subpath,filename];
    }
    
    return returnString;
}

+ (NSString *)ucaiResourcesBoundleCommonFilePath:(NSString *)filename inDirectory:(NSString *)subpath{
    
    NSString * returnString = nil;
    if (subpath==nil) {
        returnString = [NSString stringWithFormat:@"%@/Images/Common/%@.png",UCAI_RESOURCES_BUNDLE_NAME,filename];
    } else {
        returnString = [NSString stringWithFormat:@"%@/Images/Common/%@/%@.png",UCAI_RESOURCES_BUNDLE_NAME,subpath,filename];
    }
    
    return returnString;
}

+ (NSString *)ucaiResourcesBoundleDicFilePath:(NSString *)filename inDirectory:(NSString *)subpath{
    NSString * bundlePath = UCAI_RESOURCES_BUNDLE_RESOURCE_PATH;
    
    NSString * returnString = nil;
    if (subpath==nil) {
        returnString = [NSString stringWithFormat:@"%@/Dictionary/%@.plist",bundlePath,filename];
    } else {
        returnString = [NSString stringWithFormat:@"%@/Dictionary/%@/%@.plist",bundlePath,subpath,filename];
    }
    
    return returnString;
}

@end
