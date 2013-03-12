//
//  UIPiosaTableViewCell.m
//  UCAI
//
//  Created by  on 12-2-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIPiosaTableViewCell.h"

@implementation UIPiosaTableViewCell

@synthesize piosaDelegate = _piosaDelegate;

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    
    if (self.piosaDelegate && highlighted) {
		[self.piosaDelegate cellBeHighlighted:self];
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    
    if (self.piosaDelegate && selected) {
		[self.piosaDelegate cellBeSelected:self];
	}
}

@end


