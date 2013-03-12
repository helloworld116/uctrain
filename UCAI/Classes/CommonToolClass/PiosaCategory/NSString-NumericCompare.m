//
//  NSString-NumericCompare.m
//  UCAI
//
//  Created by  on 11-12-29.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "NSString-NumericCompare.h"

@implementation NSString (Support) 

- (NSComparisonResult) psuedoNumericCompare:(NSString *)otherString {
	
    NSString *left  = self;
    NSString *right = otherString;
    
	if ([left length]>[right length]) {
		return NSOrderedAscending;
	} else if ([left length]<[right length]){
		return NSOrderedDescending;
	} else {
		return NSOrderedSame;
	}
}

@end