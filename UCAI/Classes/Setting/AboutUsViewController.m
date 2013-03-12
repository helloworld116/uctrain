//
//  AboutUsViewController.m
//  JingDuTianXia
//
//  Created by Chen Menglin on 5/16/11.
//  Copyright 2011 __JingDuTianXia__. All rights reserved.
//

#import "QuartzCore/QuartzCore.h"
#import "AboutUsViewController.h"
#import "PiosaFileManager.h"

#define kNetActionSheetTag 101
#define kPhoneActionSheetTag 102

@implementation AboutUsViewController

#pragma mark -
#pragma mark Custom

- (void)netLink{
    if ([[UIApplication  sharedApplication] canOpenURL:[NSURL  URLWithString:@"http://www.ucai.com"]]) {
        UIActionSheet * netActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"前往油菜网(www.ucai.com)" otherButtonTitles:nil, nil];
        netActionSheet.delegate = self;
        netActionSheet.tag = kNetActionSheetTag;
        [netActionSheet showInView:[UIApplication sharedApplication].keyWindow];
		[netActionSheet release];
    }
}

- (void)phoneCall{
    if ([[UIApplication  sharedApplication] canOpenURL:[NSURL  URLWithString:@"tel://4006840060"]]) {
        UIActionSheet * phoneActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拨打电话40068 40060" otherButtonTitles:nil, nil];
        phoneActionSheet.delegate = self;
        phoneActionSheet.tag = kPhoneActionSheetTag;
        [phoneActionSheet showInView:[UIApplication sharedApplication].keyWindow];
		[phoneActionSheet release];
    }
}

- (void)backOrHome:(UIButton *) button
{
    switch (button.tag) {
        case 101:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case 102:
            [self.navigationController popToRootViewControllerAnimated:YES];
            break;
    }
}

- (void)loadView {
    [super loadView];
    self.title = @"关于我们";
    
    //返回按钮
    NSString *backButtonNormalPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"backButton_normal" inDirectory:@"CommonView/NavigationItem"];
    NSString *backButtonHighlightedPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"backButton_highlighted" inDirectory:@"CommonView/NavigationItem"];
    UIButton * backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    backButton.tag = 101;
    [backButton setBackgroundImage:[UIImage imageNamed:backButtonNormalPath] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:backButtonHighlightedPath] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backOrHome:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    [backBarButtonItem release];
    [backButton release];
    
    //主页按钮
    NSString *homeButtonNormalPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"homeButton_normal" inDirectory:@"CommonView/NavigationItem"];
    NSString *homeButtonHighlightedPath = [PiosaFileManager ucaiResourcesBoundleThemeFilePath:@"homeButton_highlighted" inDirectory:@"CommonView/NavigationItem"];
    UIButton * homeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    homeButton.tag = 102;
    [homeButton setBackgroundImage:[UIImage imageNamed:homeButtonNormalPath] forState:UIControlStateNormal];
    [homeButton setBackgroundImage:[UIImage imageNamed:homeButtonHighlightedPath] forState:UIControlStateHighlighted];
    [homeButton addTarget:self action:@selector(backOrHome:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *homeBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:homeButton];
    self.navigationItem.rightBarButtonItem = homeBarButtonItem;
    [homeBarButtonItem release];
    [homeButton release];
    
    UIScrollView *aboutUsScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
    
    UIView *separatorOneView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    separatorOneView.backgroundColor = [UIColor colorWithRed:0.2 green:0.4 blue:0.2 alpha:1.0];
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 80, 36)];
    NSString *titleLogoImageNormalPath = [PiosaFileManager ucaiResourcesBoundleCommonFilePath:@"titleLogo" inDirectory:@"RootView"];
    logoImageView.image = [UIImage imageNamed:titleLogoImageNormalPath];
    [separatorOneView addSubview:logoImageView];
    [logoImageView release];
    [aboutUsScrollView addSubview:separatorOneView];
    [separatorOneView release];
    
    UIView *contentOneView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, 320, 132)];
    contentOneView.backgroundColor = [UIColor whiteColor];
    UILabel *contentOneLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 0, 316, 152)];
    contentOneLabel.backgroundColor = [UIColor clearColor];
    contentOneLabel.numberOfLines = 7;
    contentOneLabel.text = @"油菜•悠行宝手机客户端\n版本号:\n适用于IOS4.0及以上版本\n\n油菜网 版权所有\nCopyrightⓒ 2007-2012, ucai.com.\nAll Rights Reserved.";
    [contentOneView addSubview:contentOneLabel];
    [contentOneLabel release];
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(58, 25, 50, 20)];
    versionLabel.backgroundColor = [UIColor clearColor];
    versionLabel.textColor = [PiosaColorManager fontColor];
    versionLabel.text = @"V2.1";
    [contentOneView addSubview:versionLabel];
    [versionLabel release];
    [aboutUsScrollView addSubview:contentOneView];
    [contentOneView release];
    
    UIView *separatorTwoView = [[UIView alloc] initWithFrame:CGRectMake(0, 172, 320, 40)];
    separatorTwoView.backgroundColor = [UIColor colorWithRed:0.2 green:0.4 blue:0.2 alpha:1.0];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 2, 200, 36)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = @"关于精度商旅平台";
    [separatorTwoView addSubview:titleLabel];
    [titleLabel release];
    [aboutUsScrollView addSubview:separatorTwoView];
    [separatorTwoView release];
    
    UIView *contentTwoView = [[UIView alloc] initWithFrame:CGRectMake(0, 212, 320, 650)];
    contentTwoView.backgroundColor = [UIColor whiteColor];
    UILabel *contentTwoLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 0, 316, 650)];
    contentTwoLabel.backgroundColor = [UIColor clearColor];
    contentTwoLabel.numberOfLines = 0;
    contentTwoLabel.text = @"1、一个可以手机上运行的商旅平台，已经接入了机票、酒店、火车票等资源，通过服务器进行这些票务数据的实时更新，任何人通过自己的联网电脑及可上网的手机及时查询机票、酒店、火车票的服务及价格信息。\n2、可通过我们的网站及手机客户端软件查询全国的机票、火车票的实时余票信息，并在线预订，订票成功后可在线支付，完成购票。可查询全国酒店的每天的各类客房的空余数量，并进行在线订房及支付。\n3、我们通过平台的规模采购优势，与大量的航空公司、酒店等达成协议，以市面上最优惠的价格提供机票及客房。\n4、我们的平台实现了市场与工厂的无缝对接，消费者与供应商直接见面交易，消费了机票及酒店的中间代理层，最大限度地让利于供应商与消费者。\n5、我们的系统国内率先实现全自动订机票及订酒店，颠覆了传统的人工订票及订酒店，大大缩减了订票订房人员及呼叫中心人员数量，大幅降低了运营成本及提高了服务效率。\n6、我们同时开发了分销平台，任何个人可通过我们的PC及平板电脑客户端软件，可以加盟推广我们的机票、火车票、酒店直销业务，实现7乘24小时无门店及无门槛创业。\n7、油菜网:\n8、联系我们:";
    [contentTwoView addSubview:contentTwoLabel];
    [contentTwoLabel release];
    
    UIButton *netButton = [[UIButton alloc] initWithFrame:CGRectMake(86, 598, 130, 20)];
    netButton.backgroundColor = [UIColor clearColor];
    [netButton setTitleColor:[UIColor colorWithRed:0.2 green:0.4 blue:0.2 alpha:1.0] forState:UIControlStateNormal];
    [netButton setTitleColor:[UIColor yellowColor] forState:UIControlStateHighlighted];
    [netButton setTitle:@"www.ucai.com" forState:UIControlStateNormal];
    [netButton addTarget:self action:@selector(netLink) forControlEvents:UIControlEventTouchUpInside];
    [contentTwoView addSubview:netButton];
    [netButton release];
    
    UIButton *phoneButton = [[UIButton alloc] initWithFrame:CGRectMake(105, 620, 110, 20)];
    phoneButton.backgroundColor = [UIColor clearColor];
    [phoneButton setTitleColor:[UIColor colorWithRed:0.2 green:0.4 blue:0.2 alpha:1.0] forState:UIControlStateNormal];
    [phoneButton setTitleColor:[UIColor yellowColor] forState:UIControlStateHighlighted];
    [phoneButton setTitle:@"40068-40060" forState:UIControlStateNormal];
    [phoneButton addTarget:self action:@selector(phoneCall) forControlEvents:UIControlEventTouchUpInside];
    [contentTwoView addSubview:phoneButton];
    [phoneButton release];
    
    [aboutUsScrollView addSubview:contentTwoView];
    [contentTwoView release];
    
    aboutUsScrollView.contentSize = CGSizeMake(320, 40+132+40+650);
    [self.view addSubview:aboutUsScrollView];
    [aboutUsScrollView release];
    
}

#pragma mark -
#pragma mark ActionSheet Delegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([actionSheet cancelButtonIndex] != buttonIndex) {
        switch (actionSheet.tag) {
            case kNetActionSheetTag:
                //跳转油菜网
                [[UIApplication  sharedApplication] openURL:[NSURL  URLWithString:@"http://www.ucai.com"]];
                break;
            case kPhoneActionSheetTag:
                //拨打客服电话
                [[UIApplication  sharedApplication] openURL:[NSURL  URLWithString:@"tel://4006840060"]];
                break;
        }
    }
}

@end
