//
//  UIPiosaTableViewCell.h
//  UCAI
//
//  Created by  on 12-2-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIPiosaTableViewCell;

@protocol UIPiosaTableViewCellDelegate <NSObject>
- (void)cellBeHighlighted:(UIPiosaTableViewCell *)cell;
- (void)cellBeSelected:(UIPiosaTableViewCell *)cell;
@end

@interface UIPiosaTableViewCell : UITableViewCell
@property(nonatomic,assign) id<UIPiosaTableViewCellDelegate> piosaDelegate;
@end
