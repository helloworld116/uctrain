//
//  ModelOverlayView.m
//  JingDuTianXia
//
//  Created by Piosa on 11-11-23.
//  Copyright 2011 __JingDuTianXia__. All rights reserved.
//

#import "ModelOverlayView.h"


@implementation ModelOverlayView


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		self.backgroundColor = [UIColor colorWithRed:0.42 green:0.70 blue:0.99 alpha:0.6f];
        _uiActivityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		_uiActivityIndicatorView.center = CGPointMake(self.center.x, self.center.y);
		[self addSubview:_uiActivityIndicatorView];
		[_uiActivityIndicatorView startAnimating];
	}
    return self;
}

- (void)dealloc {
	[_uiActivityIndicatorView stopAnimating];
	[_uiActivityIndicatorView release];
    [super dealloc];
}


@end
