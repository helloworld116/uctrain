//
//  DoubleTapSegmentedControl.h
//  JingDuTianXia
//
//  Created by Piosa on 11-10-26.
//  Copyright 2011 __JingDuTianXia__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DoubleTapSegmentedControl;

@protocol DoubleTapSegmentedControlDelegate <NSObject>
- (void) performSegmentAction: (DoubleTapSegmentedControl *) aDTSC;
@end


@interface DoubleTapSegmentedControl : UISegmentedControl
@property (nonatomic, assign) id<DoubleTapSegmentedControlDelegate> piosaDelegate;
@end


