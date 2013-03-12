//
//  CustomHistory.m
//  UCAI
//
//  Created by apple on 13-1-8.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "CustomHistory.h"

@implementation CustomHistory

+(void)saveKey:(NSString *) key withValue:(NSString *)value{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
}

+(NSString *)getValueByKey:(NSString *) key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id v = [defaults objectForKey:key];
    if (v==nil) {
        return nil; 
    }
    NSString *value = [NSString stringWithFormat:@"%@",v];
    return value;
}

@end
