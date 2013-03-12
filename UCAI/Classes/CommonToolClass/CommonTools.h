//
//  CommonTools.h
//  JingDuTianXia
//
//  Created by Chen Menglin on 4/21/11.
//  Copyright 2011 __JingDuTianXia__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <SystemConfiguration/SystemConfiguration.h>
#import <netdb.h>

#define TEXT_FIELD_TAG	9999
#define showAd  1

@interface CommonTools : NSObject

#pragma mark - 文件读写
//将数据写到Documents目录
+ (BOOL)writeApplicationData:(NSData *)data toFile:(NSString *)fileName;

//从Documents目录读取数据
+ (NSData *)applicationDataFromFile:(NSString *)fileName;

#pragma mark - 天气图片转换
//转换当前天气图片名称
+(NSString *)changToCurrentWeatherImageName:(NSString *)des;

//转换未来天气图片名称
+(NSString *)changToFeatureWeatherImageName:(NSString *)des;

#pragma mark - 格式验证
//验证手机号码的格式，正确返回true
+(BOOL)verifyPhoneFormat:(NSString *)phoneStr;

//验证邮箱的格式，正确返回true
+(BOOL)verifyEmailFormat:(NSString *)emailStr;

//验证身份证的格式，正确返回true
+(BOOL)verifyIDNumberFormat:(NSString *)idNumberStr;

//匹配日期格式 yyyyMMdd 并验证日期是否合法 用于18位身份证出生日期的验证
+(BOOL)isValidDate8:(NSString *)dateStr;

//匹配日期格式 yyMMdd 并验证日期是否合法 此方法忽略了闰年的验证 用于15位身份证出生日期的验证
+(BOOL)isValidDate6:(NSString *)dateStr;

//检查天数是否在有效的范围内，因为天数会根据年份和月份的不同而不同 所以必须依赖年份和月份进行检查
+(BOOL)isValidDay:(int)day validMonth:(int)month validYear:(int)year;

//验证是否是闰年
+(BOOL)isLeapYear:(int)year;

#pragma mark - 计算
//计算字符串在UTF-8编码下所占的字节数
+ (int)calc_charsetNum:(NSString*)_str;

//计算字符串在UTF-8编码下所占的行数，每行字节数为byteNumber
+ (NSUInteger)calculateRowCountForUTF8:(NSString*)_str bytes:(NSUInteger) byteNumber;

#pragma mark - 网络工具
+(BOOL)connectedToNetwork;//检查网络连接状态，有可用连接返回true

#pragma mark - 加解密工具
//md5
+(NSString *) md5: (NSString *) inPutText;

//AES/CBC/PKCS7Padding
+ (NSString *) aes:(NSString *)sTextIn key:(NSString *)sKey iv:(NSString *)sIv;

#pragma mark - 编码工具
// UTF8编码
+(NSString *)EncodeUTF8Str:(NSString *)encodeStr;

// GB2312编码
+(NSString *)EncodeGB2312Str:(NSString *)encodeStr;

#pragma mark - 可输入内容对话框
+(NSUInteger)ask:(NSString *)question withCancel:(NSString *)cancelButtonTitle withButtons:(NSArray *)buttons;
+(void)say:(id)formatstring,...;
+(BOOL)ask:(id)formatstring,...;
+(BOOL)confirm:(id)formatstring,...;
+(NSString *)textQueryWith:(NSString *)question prompt:(NSString *)prompt button1:(NSString *)button1 button2:(NSString *)button2;
+(NSString *)ask:(NSString *)question withTextPrompt:(NSString *)prompt;

//检查金额，如果为0，则返回-，否则返回原值
+(NSString *)checkPrice:(id)price;
@end