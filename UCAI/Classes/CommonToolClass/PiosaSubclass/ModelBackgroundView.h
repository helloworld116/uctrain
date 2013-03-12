//
//  ModelBackgroundView.h
//  UCAI
//
//  Created by  on 11-12-21.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ModelBackgroundViewDelegate <NSObject>
- (void) touchDownForCancel;
@end

@interface ModelBackgroundView : UIView
@property (nonatomic, assign) id<ModelBackgroundViewDelegate> delegate;
@end
