//
//  UIPiosaLabel.m
//  UCAI
//
//  Created by  on 12-2-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define kDeleteViewTag 10001

#import "UIPiosaLabel.h"

@implementation UIPiosaLabel

- (void)drawTextInRect:(CGRect)rect
{
    [super drawTextInRect:rect];
    CGFloat stringWidth = [self.text sizeWithFont:self.font].width;
    
    if (stringWidth != 0.0) {
        
        CGRect deleteViewRect;
        
        if (self.textAlignment == UITextAlignmentLeft) {
            deleteViewRect = CGRectMake(0, rect.size.height/2, stringWidth, 1);
        }else if (self.textAlignment == UITextAlignmentRight) {
            deleteViewRect = CGRectMake(rect.size.width-stringWidth, rect.size.height/2, stringWidth, 1);
        }
        
        UIView *deleteView = [self viewWithTag:kDeleteViewTag];
        
        if (deleteView) {
            deleteView.frame = deleteViewRect;
        }else{
            UIView *deleteNewView = [[UIView alloc] initWithFrame:deleteViewRect];
            deleteNewView.backgroundColor = [UIColor grayColor];
            deleteNewView.tag = kDeleteViewTag;
            [self addSubview:deleteNewView];
            [deleteNewView release];
        }
    }
}

@end
