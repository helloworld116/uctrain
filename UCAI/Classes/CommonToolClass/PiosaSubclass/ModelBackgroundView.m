//
//  ModelBackgroundView.m
//  UCAI
//
//  Created by  on 11-12-21.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ModelBackgroundView.h"

@implementation ModelBackgroundView

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.50 green:0.50 blue:0.50 alpha:0.7];
    }
    return self;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	[super touchesBegan:touches withEvent:event];
	if (self.delegate) {
		[self.delegate touchDownForCancel];
	}
}

@end
