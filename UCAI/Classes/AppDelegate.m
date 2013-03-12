//
//  AppDelegate.m
//  UCAI
//
//  Created by  on 11-12-1.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "PiosaColorManager.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize navController = _navController;

// 析构函数
- (void)dealloc {
    [self.navController release];
    [self.window release];
    [super dealloc];
}

#pragma mark -
#pragma mark Custom

- (void)showAllpicationState
{
    UIApplicationState state = [UIApplication sharedApplication].applicationState;
    if (state==UIApplicationStateInactive ){
        NSLog(@"-------------------------------------------------UIApplicationStateInactive");
    }else if(state==UIApplicationStateActive){
        NSLog(@"-------------------------------------------------UIApplicationStateActive");
    }else{
        NSLog(@"-------------------------------------------------UIApplicationStateBackground");
    };
}

#pragma mark -
#pragma mark Handling Remote Notifications

//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
//
//}
//
////处理请求到的设备令牌
//- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
//    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"成功获取设备令牌" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [alertView show];
//
//}
//
////处理令牌请求错误
//- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
//    NSString *status = [NSString stringWithFormat:@"Registration failed.\n\nError:%@",[error localizedDescription]];
//    
//    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:status delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [alertView show];
//}

#pragma mark -
#pragma mark Monitoring Application State Changes

//这是程序启动时调用的函数。可以在此方法中加入初始化相关的代码。
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"application: didFinishLaunchingWithOptions:");
    [self showAllpicationState];
    
    NSLog(@"NotificationType:%d",[[UIApplication sharedApplication] enabledRemoteNotificationTypes]);
    
    if ([[UIApplication sharedApplication] enabledRemoteNotificationTypes] == UIRemoteNotificationTypeNone) {
        NSLog(@"未注册通知");
        //注册通知类型:标志、声音与警告
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert];
    }
    
    
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    UINavigationController * uiNavigationController = [[UINavigationController alloc] init];
    
    RootViewController *rootViewController = [[RootViewController alloc] init];
    [uiNavigationController pushViewController:rootViewController animated:NO];
    [rootViewController release];

    
    self.navController = uiNavigationController;
    [self.window addSubview:uiNavigationController.view];
    [uiNavigationController release];
    
//    NSArray *nib= [[NSBundle mainBundle] loadNibNamed:@"RootView" owner:self options:nil];
//    RootView *rootView = (RootView *)[nib objectAtIndex:0];
//    NSLog(@"rootview height is %f",rootView.frame.size.height);
//    
//    RootView *rootView = [[[RootView alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
//    [self.window addSubview:rootView];
    
//    self.window.backgroundColor = [PiosaColorManager fontColor];
    [self.window makeKeyAndVisible];
    
    [UIView beginAnimations:nil context:nil];  
    [UIView setAnimationDuration:3.0];  
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView: self.window cache:YES];  
    [UIView setAnimationDelegate:self];    
    [UIView commitAnimations];

//    [[UIScreen mainScreen] bounds].size.width
//    self.adView = [[WQAdView alloc] init];
//    [self.adView setFrame:CGRectMake(0, 366, 320, 50)];
//    [self.adView startWithAdSlotID:kAdslotID AccountKey:kAccountKey InViewController:nil];
    return YES;
}

// 应用在准备进入前台运行时执行的函数。（当应用从启动到前台，或从后台转入前台都会调用此方法）
//重启应用程序在闲置时被停止(或还未开始的)任务。如果应用程序先前是在后台中，则选择性地刷新界面
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"applicationDidBecomeActive:");
    [self showAllpicationState];
}

//应用当前正要从前台运行状态离开时执行的函数。
- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"applicationWillResignActive:");
    [self showAllpicationState];
}

//此时应用处在background状态，并且没有执行任何代码，未来将被挂起进入suspended状态。
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"applicationDidEnterBackground:");
    [self showAllpicationState];
}

//当前应用正从后台移入前台运行状态，但是当前还没有到Active状态时执行的函数。
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"applicationWillEnterForeground:");
    [self showAllpicationState];
}

//当前应用即将被终止，在终止前调用的函数。如果应用当前处在suspended，此方法不会被调用。
- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"applicationWillTerminate:");
    [self showAllpicationState];
}


- (void)applicationDidFinishLaunching:(UIApplication *)application
{
    NSLog(@"applicationDidFinishLaunching:");
    [self showAllpicationState];
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application 
{
    NSLog(@"applicationDidReceiveMemoryWarning");
    [self showAllpicationState];
}

@end
