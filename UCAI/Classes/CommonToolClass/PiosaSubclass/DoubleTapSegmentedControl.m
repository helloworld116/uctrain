//
//  DoubleTapSegmentedControl.m
//  JingDuTianXia
//
//  Created by Piosa on 11-10-26.
//  Copyright 2011 __JingDuTianXia__. All rights reserved.
//

#import "DoubleTapSegmentedControl.h"

@implementation DoubleTapSegmentedControl

@synthesize piosaDelegate = _piosaDelegate;

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	[super touchesBegan:touches withEvent:event];
	if (self.piosaDelegate) {
		[self.piosaDelegate performSegmentAction:self];
	}
}

@end
