//
//  CustomHistory.h
//  UCAI
//
//  Created by apple on 13-1-8.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomHistory : NSObject

+(void)saveKey:(NSString *) key withValue:(NSString *)value;

+(NSString *)getValueByKey:(NSString *) key;

@end
