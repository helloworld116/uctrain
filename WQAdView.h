//
//  WQAdView.h
//  
//
//  Created by WQMobile.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define kAdslotID @"4bdde4aac6cdea4abed485425733ae55"
#define kAccountKey @"76b02584d1a52bd8aac47f73fe5ddbd4"
//#define kAdslotID @"a912fb92524c8e08541439d43fec9eaf"
//#define kAccountKey @"c73d49b0e4a05f3993e4b25eee44623f"


@class WQAdView;

@protocol WQAdViewDelegate;
@protocol WQAdViewDelegate <NSObject>
@optional

//广告视图获取广告成功
- (void)onWQAdReceived:(WQAdView *)adview;

//广告视图获取广告失败
- (void)onWQAdFailed:(WQAdView *)adview;

//广告视图将要关闭
- (void)onWQAdDismiss:(WQAdView *)adview;

//广告视图获取缓慢提醒
- (void)onWQAdLoadTimeout:(WQAdView*) adview;

@end
@interface WQAdView : UIView
@property(nonatomic,retain) id <WQAdViewDelegate> delegate;

//广告视图初始化（不使用位置服务）
- (id)init;

//广告视图初始化，是否使用位置服务
- (id)init:(BOOL)enableLocation;

//广告视图初始化并使用位置服务
- (id)initWithLocation;

//广告视图使用frame初始化（不使用位置服务）
- (id)initWithFrame:(CGRect)frame;

//广告视图使用frame初始化并使用位置服务
- (id)initWithLocationWithFrame:(CGRect)frame;

//通过使用提供的AdSlotID和AccountKey在指定的controller中开始获取广告（controller可为nil）
- (void)startWithAdSlotID:(NSString *)adslotid AccountKey:(NSString *)accountKey InViewController:(UIViewController *)controller;

@end
