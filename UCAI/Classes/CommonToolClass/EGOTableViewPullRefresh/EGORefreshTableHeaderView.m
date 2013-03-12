//
//  EGORefreshTableHeaderView.m
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

//  修改了
//  initWithFrame
//  egoRefreshScrollViewDidScroll
//  egoRefreshScrollViewDidEndDragging
//  三个方法中的位置判断参数，使得更新视图位于下方

#import "EGORefreshTableHeaderView.h"
#import "PiosaFileManager.h"


#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0] //默认字体颜色
#define FLIP_ANIMATION_DURATION 0.18f

#define  REFRESH_VIEW_HIGHT 65.0f //刷新视图变化的高度

@interface EGORefreshTableHeaderView (Private)
- (void)setState:(EGOPullRefreshState)aState;
@end

@implementation EGORefreshTableHeaderView

@synthesize delegate=_delegate;


- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor  {
    if((self = [super initWithFrame:frame])) {
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = [UIColor clearColor];
		
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 30.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont systemFontOfSize:12.0f];
		label.textColor = textColor;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		[self addSubview:label];
		_lastUpdatedLabel=label;
		[label release];
		
		label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 10.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontOfSize:13.0f];
		label.textColor = textColor;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label;
		[label release];
		
		CALayer *layer = [CALayer layer];
		layer.frame = CGRectMake(25.0f, frame.size.height - REFRESH_VIEW_HIGHT, 30.0f, 55.0f);
		layer.contentsGravity = kCAGravityResizeAspect;
		layer.contents = (id)[UIImage imageNamed:arrow].CGImage;
		
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			layer.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		
		[[self layer] addSublayer:layer];
		_arrowImage=layer;
		
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		view.frame = CGRectMake(25.0f, 20.0f, 20.0f, 20.0f);
		[self addSubview:view];
		_activityView = view;
		[view release];
		
		[self setState:EGOOPullRefreshNormal];
    }
	
    return self;
}

- (id)initWithFrame:(CGRect)frame  {
    NSString *jdBlackArrowImageNormalPath = [PiosaFileManager ucaiResourcesBoundleCommonFilePath:@"JDBlackArrow" inDirectory:@"EGOTableViewPullRefresh"];
    return [self initWithFrame:frame arrowImageName:jdBlackArrowImageNormalPath textColor:[UIColor blackColor]];
}

#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate {
	
	if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceLastUpdated:)]) {
		
		NSDate *date = [_delegate egoRefreshTableHeaderDataSourceLastUpdated:self];
		
		[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
		NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];

		_lastUpdatedLabel.text = [NSString stringWithFormat:@"上一次加载时间: %@", [dateFormatter stringFromDate:date]];
		[[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"EGORefreshTableView_LastRefresh"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	} else {
		_lastUpdatedLabel.text = nil;
		
	}

}

- (void)setState:(EGOPullRefreshState)aState{
	
	switch (aState) {
		case EGOOPullRefreshPulling:
			//设置视图状态为拉动状态时
			_statusLabel.text = NSLocalizedString(@"松开可以加载更多...", @"Release to refresh status");
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			
			break;
		case EGOOPullRefreshNormal:
			//设置视图状态为普通状态时
			if (_state == EGOOPullRefreshPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
			
			_statusLabel.text = NSLocalizedString(@"上拉加载更多...", @"Pull down to refresh status");
			[_activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = NO;
			_arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			
			[self refreshLastUpdatedDate];
			
			break;
		case EGOOPullRefreshLoading:
			//设置视图状态为更新状态时
			_statusLabel.text = NSLocalizedString(@"加载中...", @"Loading Status");
			[_activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = YES;
			[CATransaction commit];
			
			break;
		default:
			break;
	}
	
	_state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

//手指屏幕上不断拖动时调用此方法
- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView{
	if (scrollView.contentSize.height != 0) {
        //获取scollView向上拉动后显示出拉动刷新框的距离
        CGFloat distance = scrollView.contentOffset.y + scrollView.frame.size.height - scrollView.contentSize.height;
        
        if (_state == EGOOPullRefreshLoading) {
            //视图状态为更新状态时
            CGFloat offset = MAX(distance, 0);
            offset = MIN(offset, 60);
            scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, offset, 0.0f);
            
        } else if (scrollView.isDragging) {
            //正在拖动列表时
            BOOL _loading = NO;
            if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
                //获取列表是否正在更新
                _loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
            }
            
            if (_state == EGOOPullRefreshPulling && distance < REFRESH_VIEW_HIGHT && distance > 0.0f && !_loading) {
                //当列表状态是正在拉动，并且列表拉出框高度在0到65间，并且不是在更新。则设置视图状态为正常状态
                [self setState:EGOOPullRefreshNormal];
            } else if (_state == EGOOPullRefreshNormal && distance > REFRESH_VIEW_HIGHT && !_loading) {
                //当视图状态为正常状态，并且列表拉出框高度大于65，并且不是在更新。则设置视图状态为拉动状态
                [self setState:EGOOPullRefreshPulling];
            }
            
            if (scrollView.contentInset.bottom != 0) {
                scrollView.contentInset = UIEdgeInsetsZero;
            }
            
        }
    }
}

//当用户停止拖动，并且手指从屏幕中拿开的时候调用此方法
- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
    if (scrollView.contentSize.height != 0) {
        //获取scollView向上拉动后显示出拉动刷新框的距离
        CGFloat distance = scrollView.contentOffset.y + scrollView.frame.size.height - scrollView.contentSize.height;
        
        //初始化是否正在更新数据的标识为否
        BOOL _loading = NO;
        if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
            //获取列表是否正在更新
            _loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
        }
        
        if (distance >= REFRESH_VIEW_HIGHT && !_loading) {
            //当列表拉出框高度大于65，并且不是在更新
            if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:)]) {
                
                //通知委托来调用协议EGORefreshTableHeaderDelegate中的egoRefreshTableHeaderDidTriggerRefresh方法
                [_delegate egoRefreshTableHeaderDidTriggerRefresh:self];
            }
            
            [self setState:EGOOPullRefreshLoading];//设置视图状态为正在更新
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.2];
            scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 60.0f, 0.0f);//设置列表的位置
            [UIView commitAnimations];
            
        }
    }
}

//当开发者页面页面刷新完毕调用此方法，[delegate egoRefreshScrollViewDataSourceDidFinishedLoading: scrollView];
- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {	
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];//列表位置变换
	[UIView commitAnimations];
	
	[self setState:EGOOPullRefreshNormal];//设置列表状态为普通状态

}


#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	
	_delegate=nil;
	_activityView = nil;
	_statusLabel = nil;
	_arrowImage = nil;
	_lastUpdatedLabel = nil;
    [super dealloc];
}


@end
