//
//  CommonTools.m
//  JingDuTianXia
//
//  Created by Chen Menglin on 4/21/11.
//  Copyright 2011 __JingDuTianXia__. All rights reserved.
//

#import "CommonTools.h"
#import <stdarg.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"


// 可输入内容对话框
@interface ModalAlertDelegate : NSObject <UIAlertViewDelegate, UITextFieldDelegate> 
{
	CFRunLoopRef currentLoop;
	NSString *text;
	NSUInteger index;
}
@property (assign) NSUInteger index;
@property (retain) NSString *text;
@end

@implementation ModalAlertDelegate
@synthesize index;
@synthesize text;

-(id) initWithRunLoop: (CFRunLoopRef)runLoop 
{
	if (self = [super init]) currentLoop = runLoop;
	return self;
}

// User pressed button. Retrieve results
-(void)alertView:(UIAlertView*)aView clickedButtonAtIndex:(NSInteger)anIndex 
{
	UITextField *tf = (UITextField *)[aView viewWithTag:TEXT_FIELD_TAG];
	// 设置键盘属性: 中文输入
	
	if (tf) {
		self.text = tf.text;
		tf.keyboardType = UIKeyboardTypeASCIICapable;
		tf.autocapitalizationType = UITextAutocapitalizationTypeNone;
	}
	self.index = anIndex;
	CFRunLoopStop(currentLoop);
}

// Move alert into place to allow keyboard to appear
- (void) moveAlert: (UIAlertView *) alertView
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.1f];

	alertView.center = CGPointMake(160.0f, 200.0f);
	
	[UIView commitAnimations];
	
	[[alertView viewWithTag:TEXT_FIELD_TAG] becomeFirstResponder];
}

- (void) dealloc
{
	self.text = nil;
	[super dealloc];
}

@end

@implementation CommonTools

#pragma mark - 文件读写
+ (BOOL)writeApplicationData:(NSData *)data toFile:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    if (!documentsDirectory) {
        NSLog(@"Documents directory not found!");
        return NO;
    }
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
    return ([data writeToFile:appFile atomically:YES]);
}

+ (NSData *)applicationDataFromFile:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
    NSData *myData = [[[NSData alloc] initWithContentsOfFile:appFile] autorelease];
    return myData;
}

#pragma mark - 天气图片转换

+(NSString *)changToCurrentWeatherImageName:(NSString *)des{
    
	NSPredicate *sIconStorm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@" , @"[a-z._/]*(thunder|tstms)[a-z._/]*" ];
	NSPredicate *sIconShower = [NSPredicate predicateWithFormat:@"SELF MATCHES %@" , @"[a-z._/]*(showers)[a-z._/]*" ];
	NSPredicate *sIconClouds = [NSPredicate predicateWithFormat:@"SELF MATCHES %@" , @"[a-z._/]*(cloud|overcast)[a-z._/]*" ];
	NSPredicate *sIconPartlyCloudy = [NSPredicate predicateWithFormat:@"SELF MATCHES %@" , @"[a-z._/]*(partly_cloudy|mostly_sunny)[a-z._/]*" ];
	NSPredicate *sIconMostCloudy = [NSPredicate predicateWithFormat:@"SELF MATCHES %@" , @"[a-z._/]*(most_cloudy)[a-z._/]*" ];
	NSPredicate *sIconLightrain = [NSPredicate predicateWithFormat:@"SELF MATCHES %@" , @"[a-z._/]*(lightrain)[a-z._/]*" ];
	NSPredicate *sIconChanceOfRain = [NSPredicate predicateWithFormat:@"SELF MATCHES %@" , @"[a-z._/]*(chance_of_rain)[a-z._/]*" ];
    NSPredicate *sIconChanceOfSnow = [NSPredicate predicateWithFormat:@"SELF MATCHES %@" , @"[a-z._/]*(chance_of_snow)[a-z._/]*" ];
	NSPredicate *sIconHeavyrain = [NSPredicate predicateWithFormat:@"SELF MATCHES %@" , @"[a-z._/]*(heavyrain)[a-z._/]*" ];
	NSPredicate *sIconRain = [NSPredicate predicateWithFormat:@"SELF MATCHES %@" , @"[a-z._/]*(rain|storm)[a-z._/]*" ];
    NSPredicate *sIconSnow = [NSPredicate predicateWithFormat:@"SELF MATCHES %@" , @"[a-z._/]*(snow|ice|frost|flurries)[a-z._/]*" ];
    NSPredicate *sIconHaze = [NSPredicate predicateWithFormat:@"SELF MATCHES %@" , @"[a-z._/]*(haze)[a-z._/]*" ];
    NSPredicate *sIconSun = [NSPredicate predicateWithFormat:@"SELF MATCHES %@" , @"[a-z._/]*(sunny|breezy|clear)[a-z._/]*" ];
	NSPredicate *sIconFog = [NSPredicate predicateWithFormat:@"SELF MATCHES %@" , @"[a-z._/]*(fog)[a-z._/]*" ];
    
	if ([sIconStorm evaluateWithObject:des]) {
        return [PiosaFileManager ucaiResourcesBoundleCommonFilePath:@"weather_chancestorm" inDirectory:@"Weather"];
	}if ([sIconShower evaluateWithObject:des]) {
        return [PiosaFileManager ucaiResourcesBoundleCommonFilePath:@"weather_rain" inDirectory:@"Weather"];
	}if ([sIconClouds evaluateWithObject:des]) {
        return [PiosaFileManager ucaiResourcesBoundleCommonFilePath:@"weather_cloudy" inDirectory:@"Weather"];
	} if ([sIconPartlyCloudy evaluateWithObject:des]) {
        return [PiosaFileManager ucaiResourcesBoundleCommonFilePath:@"weather_mostlysunny" inDirectory:@"Weather"];
	} if ([sIconMostCloudy evaluateWithObject:des]) {
        return [PiosaFileManager ucaiResourcesBoundleCommonFilePath:@"weather_mostlycloudy" inDirectory:@"Weather"];
	} if ([sIconLightrain evaluateWithObject:des]) {
        return [PiosaFileManager ucaiResourcesBoundleCommonFilePath:@"weather_lightrain" inDirectory:@"Weather"];
	} if ([sIconChanceOfRain evaluateWithObject:des]) {
        return [PiosaFileManager ucaiResourcesBoundleCommonFilePath:@"weather_cloudyrain" inDirectory:@"Weather"];
	} if ([sIconChanceOfSnow evaluateWithObject:des]) {
        return [PiosaFileManager ucaiResourcesBoundleCommonFilePath:@"weather_chancesnow" inDirectory:@"Weather"];
	} if ([sIconHeavyrain evaluateWithObject:des]) {
        return [PiosaFileManager ucaiResourcesBoundleCommonFilePath:@"weather_rain" inDirectory:@"Weather"];
	} if ([sIconRain evaluateWithObject:des]) {
        return [PiosaFileManager ucaiResourcesBoundleCommonFilePath:@"weather_rain" inDirectory:@"Weather"];
	} if ([sIconSnow evaluateWithObject:des]) {
        return [PiosaFileManager ucaiResourcesBoundleCommonFilePath:@"weather_snow" inDirectory:@"Weather"];
	}  if ([sIconHaze evaluateWithObject:des]) {
        return [PiosaFileManager ucaiResourcesBoundleCommonFilePath:@"weather_haze" inDirectory:@"Weather"];
	} if ([sIconSun evaluateWithObject:des]) {
        return [PiosaFileManager ucaiResourcesBoundleCommonFilePath:@"weather_sunny" inDirectory:@"Weather"];
	}  if ([sIconFog evaluateWithObject:des]) {
        return [PiosaFileManager ucaiResourcesBoundleCommonFilePath:@"weather_fog" inDirectory:@"Weather"];
	} else {
        return [PiosaFileManager ucaiResourcesBoundleCommonFilePath:@"false" inDirectory:@"Weather"];
	}
}

+(NSString *)changToFeatureWeatherImageName:(NSString *)des{
    
	NSPredicate *sIconStorm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@" , @"[a-z._/]*(thunder|tstms)[a-z._/]*" ];
	NSPredicate *sIconSnow = [NSPredicate predicateWithFormat:@"SELF MATCHES %@" , @"[a-z._/]*(snow|ice|frost|flurries)[a-z._/]*" ];
	NSPredicate *sIconShower = [NSPredicate predicateWithFormat:@"SELF MATCHES %@" , @"[a-z._/]*(showers)[a-z._/]*" ];
	NSPredicate *sIconSun = [NSPredicate predicateWithFormat:@"SELF MATCHES %@" , @"[a-z._/]*(sunny|breezy|clear)[a-z._/]*" ];
	NSPredicate *sIconClouds = [NSPredicate predicateWithFormat:@"SELF MATCHES %@" , @"[a-z._/]*(cloud|overcast)[a-z._/]*" ];
	NSPredicate *sIconPartlyCloudy = [NSPredicate predicateWithFormat:@"SELF MATCHES %@" , @"[a-z._/]*(partly_cloudy|mostly_sunny)[a-z._/]*" ];
	NSPredicate *sIconMostCloudy = [NSPredicate predicateWithFormat:@"SELF MATCHES %@" , @"[a-z._/]*(most_cloudy)[a-z._/]*" ];
	NSPredicate *sIconLightrain = [NSPredicate predicateWithFormat:@"SELF MATCHES %@" , @"[a-z._/]*(lightrain)[a-z._/]*" ];
	NSPredicate *sIconChanceOfRain = [NSPredicate predicateWithFormat:@"SELF MATCHES %@" , @"[a-z._/]*(chance_of_rain)[a-z._/]*" ];
	NSPredicate *sIconHeavyrain = [NSPredicate predicateWithFormat:@"SELF MATCHES %@" , @"[a-z._/]*(heavyrain)[a-z._/]*" ];
	NSPredicate *sIconRain = [NSPredicate predicateWithFormat:@"SELF MATCHES %@" , @"[a-z._/]*(rain|storm)[a-z._/]*" ];
	NSPredicate *sIconHaze = [NSPredicate predicateWithFormat:@"SELF MATCHES %@" , @"[a-z._/]*(haze)[a-z._/]*" ];
	NSPredicate *sIconFog = [NSPredicate predicateWithFormat:@"SELF MATCHES %@" , @"[a-z._/]*(fog)[a-z._/]*" ];
    
	if ([sIconStorm evaluateWithObject:des]) {
        return [PiosaFileManager ucaiResourcesBoundleCommonFilePath:@"weather_chancestorm" inDirectory:@"Weather"];
	} if ([sIconSnow evaluateWithObject:des]) {
        return [PiosaFileManager ucaiResourcesBoundleCommonFilePath:@"weather_chancesnow" inDirectory:@"Weather"];
	} if ([sIconShower evaluateWithObject:des]) {
        return [PiosaFileManager ucaiResourcesBoundleCommonFilePath:@"weather_rain" inDirectory:@"Weather"];
	} if ([sIconSun evaluateWithObject:des]) {
        return [PiosaFileManager ucaiResourcesBoundleCommonFilePath:@"weather_sunny" inDirectory:@"Weather"];
	} if ([sIconClouds evaluateWithObject:des]) {
        return [PiosaFileManager ucaiResourcesBoundleCommonFilePath:@"weather_cloudy" inDirectory:@"Weather"];
	} if ([sIconPartlyCloudy evaluateWithObject:des]) {
        return [PiosaFileManager ucaiResourcesBoundleCommonFilePath:@"weather_mostlysunny" inDirectory:@"Weather"];
	} if ([sIconMostCloudy evaluateWithObject:des]) {
        return [PiosaFileManager ucaiResourcesBoundleCommonFilePath:@"weather_mostlycloudy" inDirectory:@"Weather"];
	} if ([sIconLightrain evaluateWithObject:des]) {
        return [PiosaFileManager ucaiResourcesBoundleCommonFilePath:@"weather_lightrain" inDirectory:@"Weather"];
	} if ([sIconChanceOfRain evaluateWithObject:des]) {
        return [PiosaFileManager ucaiResourcesBoundleCommonFilePath:@"weather_cloudyrain" inDirectory:@"Weather"];
	} if ([sIconHeavyrain evaluateWithObject:des]) {
        return [PiosaFileManager ucaiResourcesBoundleCommonFilePath:@"weather_rain" inDirectory:@"Weather"];
	} if ([sIconRain evaluateWithObject:des]) {
        return [PiosaFileManager ucaiResourcesBoundleCommonFilePath:@"weather_rain" inDirectory:@"Weather"];
	} if ([sIconHaze evaluateWithObject:des]) {
        return [PiosaFileManager ucaiResourcesBoundleCommonFilePath:@"weather_haze" inDirectory:@"Weather"];
	} if ([sIconFog evaluateWithObject:des]) {
        return [PiosaFileManager ucaiResourcesBoundleCommonFilePath:@"weather_fog" inDirectory:@"Weather"];
	} else {
        return [PiosaFileManager ucaiResourcesBoundleCommonFilePath:@"false" inDirectory:@"Weather"];
	}
}

#pragma mark - 格式验证

+ (BOOL)verifyPhoneFormat:(NSString *)phoneStr{
	// 电话号码字符串 130到139 和 150，152 ，157，158，159 ，186，189，187
	// 1、(13[0-9])|(15[02789])|(18[679]) 13段 或者15段 18段的匹配
	// 2、\\d{8} 整数出现8次
	//判断所填手机号是否符合手机格式
	NSString *phoneRegex = @"(13|15|18)[0-9]{9}"; 
	NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
	if ([phoneTest evaluateWithObject:phoneStr]) {
		return TRUE;
	} else {
		return FALSE;
	}
}

+ (BOOL)verifyEmailFormat:(NSString *)emailStr{
	NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	if ([emailTest evaluateWithObject:emailStr]) {
		return TRUE;
	} else {
		return FALSE;
	}
}

+ (BOOL)verifyIDNumberFormat:(NSString *)idNumberStr{
	NSString *eighteenIdRegex = @"^\\d{17}(\\d{1}|x|X)$";
	NSPredicate *eighteenIdTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", eighteenIdRegex];
	
	NSString *fifteenIdRegex = @"^\\d{15}$";
	NSPredicate *fifteenIdTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", fifteenIdRegex];
	
	BOOL flag = FALSE;
	
	if ([eighteenIdTest evaluateWithObject:idNumberStr]){ // 18位身份证号码验证通过
		if ([self isValidDate8:[idNumberStr substringWithRange:NSMakeRange(6, 8)]]) {
			flag = TRUE;
		}
	}
	if ([fifteenIdTest evaluateWithObject:idNumberStr]){ // 15位身份证号码验证通过
		if ([self isValidDate6:[idNumberStr substringWithRange:NSMakeRange(6, 6)]]) {
			flag = TRUE;
		}
	}
	return flag;
}

+(BOOL)isValidDate8:(NSString *)dateStr{
	NSPredicate *dateTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^\\d{4}\\d{2}\\d{2}$"];
	
	if ([dateTest evaluateWithObject:dateStr]) // 格式验证通过 yyyyMMdd
	{
		int year = [[dateStr substringWithRange:NSMakeRange(0,4)] intValue]; //年
		int month = [[dateStr substringWithRange:NSMakeRange(4,2)] intValue]; // 月
		int day = [[dateStr substringWithRange:NSMakeRange(6,2)] intValue]; // 日
		if (!(year >= 1900 && year <= 2101))
		{
			return FALSE; // 年份不合法
		}
		if (!(month >= 1 && month <= 12))
		{
			return FALSE; // 月份不合法
		}
		if (![self isValidDay:day validMonth:month validYear:year])
		{
			return FALSE; // 日期不合法
		}
		return TRUE;
	} else {
		return FALSE;
	}
	
}

+(BOOL)isValidDate6:(NSString *)dateStr{
	int DAYS_OF_MONTH[12] = {31,28,31,30,31,30,31,31,30,31,30,31};
	NSPredicate *dateTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^\\d{2}\\d{2}\\d{2}$"];
	
	if ([dateTest evaluateWithObject:dateStr]) // 格式验证通过 yyMMdd
	{
		int month = [[dateStr substringWithRange:NSMakeRange(2,2)] intValue]; // 月
		int day = [[dateStr substringWithRange:NSMakeRange(4,2)] intValue]; // 日
		if (!(month >= 1 && month <= 12))
		{
			return FALSE; // 月份不合法
		}
		if (!(day >= 1 && day <= DAYS_OF_MONTH[month-1]))
		{
			return FALSE; // 日期不合法
		}
		return TRUE;
	} else {
		return FALSE;
	}
}

+(BOOL)isValidDay:(int)day validMonth:(int)month validYear:(int)year{
	int DAYS_OF_MONTH[12] = {31,28,31,30,31,30,31,31,30,31,30,31};
	if (month == 2 && [self isLeapYear:year])// 闰年且是2月份
	{
		return day >= 1 && day <= 29;
	}
	return day >= 1 && day <= DAYS_OF_MONTH[month - 1];// 其他月份
}

+(BOOL)isLeapYear:(int)year{
	return (year % 4 == 0 && year % 100 != 0) || year % 400 == 0;
}

#pragma mark - 计算

+ (int)calc_charsetNum:(NSString*)_str
{
	unsigned result = 0;
	const char *tchar=[_str UTF8String];
	if (NULL == tchar) {
		return result;
	}
	result = strlen(tchar);
	return result;
}

+ (NSUInteger)calculateRowCountForUTF8:(NSString*)_str bytes:(NSUInteger) byteNumber{
    
    unsigned len = 0;
	const char *tchar=[_str UTF8String];
	if (NULL == tchar) {
		return 0;
	}
	len = strlen(tchar);
    
    int num = len/byteNumber;
    int yu = len%byteNumber;
    if (yu != 0) {
        num += 1;
    }
    return num;
}

#pragma mark - 网络工具

+ (BOOL) connectedToNetwork
{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);    
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags) 
    {
        printf("Error. Could not recover network reachability flags\n");
        return NO;
    }
    
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
    return (isReachable && !needsConnection) ? YES : NO;
}

#pragma mark - 加解密工具

+ (NSString *) md5: (NSString *) inPutText {
	const char *cStr = [inPutText UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5(cStr, strlen(cStr), result);
	
	return [[NSString stringWithFormat: @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			 result[0], result[1], result[2], result[3],
			 result[4], result[5], result[6], result[7],
			 result[8], result[9], result[10], result[11],
			 result[12], result[13], result[14], result[15]
			 ] lowercaseString];
}

+ (NSString *) aes:(NSString *)sTextIn key:(NSString *)sKey iv:(NSString *)sIv{
	NSStringEncoding EnC = NSUTF8StringEncoding;
    NSMutableData * dTextIn = [[sTextIn dataUsingEncoding: EnC] mutableCopy];
    NSMutableData * dKey = [[sKey dataUsingEncoding:EnC] mutableCopy];
	NSMutableData * dIv = [[sIv dataUsingEncoding:EnC] mutableCopy];
	
    NSUInteger dataLength = [dTextIn length];
	
	//See the doc: For block ciphers, the output size will always be less than or 
	//equal to the input size plus the size of one block.
	//That's why we need to add the size of one block here
	size_t bufferSize = dataLength + kCCBlockSizeAES128;
	void *buffer = malloc(bufferSize);
	size_t numBytesEncrypted = 0;
    CCCryptorStatus ccStatus = CCCrypt(kCCEncrypt, // CCOperation op    (kCCEncrypt/kCCDecrypt)
									   kCCAlgorithmAES128, // CCAlgorithm alg
									   kCCOptionPKCS7Padding, // CCOptions options
									   [dKey bytes], // const void *key
									   [dKey length], // size_t keyLength
									   [dIv bytes], // const void *iv
									   [dTextIn bytes], // const void *dataIn
									   [dTextIn length],  // size_t dataInLength
									   buffer, // void *dataOut
									   bufferSize,     // size_t dataOutAvailable
									   &numBytesEncrypted);      // size_t *dataOutMoved   
	if (ccStatus == kCCSuccess) NSLog(@"SUCCESS");
    else if (ccStatus == kCCParamError) NSLog(@"PARAM ERROR");
	else if (ccStatus == kCCBufferTooSmall) NSLog(@"BUFFER TOO SMALL");
	else if (ccStatus == kCCMemoryFailure) NSLog(@"MEMORY FAILURE");
	else if (ccStatus == kCCAlignmentError) NSLog(@"ALIGNMENT");
	else if (ccStatus == kCCDecodeError) NSLog(@"DECODE ERROR");
	else if (ccStatus == kCCUnimplemented) NSLog(@"UNIMPLEMENTED");
    
    [dTextIn release];
    [dKey release];
    [dIv release];
	
    NSString * sResult = [GTMBase64 stringByEncodingData:[NSData dataWithBytes:buffer length:numBytesEncrypted]];
    free(buffer);
	return sResult;
}

#pragma mark - 编码工具

// 把汉字单独转成UTF-8, 否则无法完成网络查询
+(NSString *)EncodeUTF8Str:(NSString *)encodeStr
{  
    CFStringRef nonAlphaNumValidChars = CFSTR("![        DISCUZ_CODE_1        ]’()*+,-./:;=?@_~");          
    NSString *preprocessedString = (NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)encodeStr, CFSTR(""), kCFStringEncodingUTF8);          
    NSString *newStr = [(NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)preprocessedString,NULL,nonAlphaNumValidChars,kCFStringEncodingUTF8) autorelease];  
    [preprocessedString release];  
    return newStr;          
}
 
+(NSString *)EncodeGB2312Str:(NSString *)encodeStr{  
    CFStringRef nonAlphaNumValidChars = CFSTR("![        DISCUZ_CODE_1        ]’()*+,-./:;=?@_~");          
    NSString *preprocessedString = (NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)encodeStr, CFSTR(""), kCFStringEncodingGB_18030_2000);          
    NSString *newStr = [(NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)preprocessedString,NULL,nonAlphaNumValidChars,kCFStringEncodingGB_18030_2000) autorelease];  
    [preprocessedString release];  
    return newStr;          
} 
/*
 或者用JSON来解析 #import "JSON/JSON.h"
 NSString *str = @"{\"id\":\"http://www.ucai.com:8080/accuracy/spi/TrainInfoServlet.do?fromCity=上海&toCity=北京&sDate=2011-04-25&num=1\"}";
 [str JSONValue] 得到的value是编码过的UTF-8字段，而且只会对汉字编码
 */

#pragma mark - 可输入内容对话框

+ (NSUInteger)ask:(NSString *)question withCancel:(NSString *)cancelButtonTitle withButtons:(NSArray *)buttons
{
	CFRunLoopRef currentLoop = CFRunLoopGetCurrent();
	
	// Create Alert
	ModalAlertDelegate *madelegate = [[ModalAlertDelegate alloc] initWithRunLoop:currentLoop];
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:question message:nil delegate:madelegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
	for (NSString *buttonTitle in buttons) [alertView addButtonWithTitle:buttonTitle];
	[alertView show];
	
	// Wait for response
	CFRunLoopRun();
	
	// Retrieve answer
	NSUInteger answer = madelegate.index;
	[alertView release];
	[madelegate release];
	return answer;
}

+ (void)say:(id)formatstring,...
{
	va_list arglist;
	va_start(arglist, formatstring);
	id statement = [[NSString alloc] initWithFormat:formatstring arguments:arglist];
	va_end(arglist);
	[CommonTools ask:statement withCancel:@"Okay" withButtons:nil];
	[statement release];
}

+ (BOOL)ask:(id)formatstring,...
{
	va_list arglist;
	va_start(arglist, formatstring);
	id statement = [[NSString alloc] initWithFormat:formatstring arguments:arglist];
	va_end(arglist);
	BOOL answer = ([CommonTools ask:statement withCancel:nil withButtons:[NSArray arrayWithObjects:@"是", @"否", nil]] == 0);
	[statement release];
	return answer;
}

+ (BOOL)confirm:(id)formatstring,...
{
	va_list arglist;
	va_start(arglist, formatstring);
	id statement = [[NSString alloc] initWithFormat:formatstring arguments:arglist];
	va_end(arglist);
	BOOL answer = [CommonTools ask:statement withCancel:@"Cancel" withButtons:[NSArray arrayWithObject:@"OK"]];
	[statement release];
	return	answer;
}

+ (NSString *)textQueryWith:(NSString *)question prompt:(NSString *)prompt button1:(NSString *)button1 button2:(NSString *)button2
{
	// Create alert
	CFRunLoopRef currentLoop = CFRunLoopGetCurrent();
	ModalAlertDelegate *madelegate = [[ModalAlertDelegate alloc] initWithRunLoop:currentLoop];
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:question message:@"\n" delegate:madelegate cancelButtonTitle:button1 otherButtonTitles:button2, nil];
	
	// Build text field
	UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 260.0f, 30.0f)];
	tf.borderStyle = UITextBorderStyleRoundedRect;
	tf.tag = TEXT_FIELD_TAG;
	tf.placeholder = prompt;
	tf.clearButtonMode = UITextFieldViewModeWhileEditing;
	tf.keyboardType = UIKeyboardTypeAlphabet;
	tf.keyboardAppearance = UIKeyboardAppearanceAlert;
	tf.autocapitalizationType = UITextAutocapitalizationTypeWords;
	tf.autocorrectionType = UITextAutocorrectionTypeNo;
	tf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	
	// Show alert and wait for it to finish displaying
	[alertView show];
	while (CGRectEqualToRect(alertView.bounds, CGRectZero));
	
	// Find the center for the text field and add it
	CGRect bounds = alertView.bounds;
	tf.center = CGPointMake(bounds.size.width / 2.0f, bounds.size.height / 2.0f - 10.0f);
	[alertView addSubview:tf];
	[tf release];
	
	// Set the field to first responder and move it into place
	[madelegate performSelector:@selector(moveAlert:) withObject:alertView afterDelay: 0.7f];
	
	// Start the run loop
	CFRunLoopRun();
	
	// Retrieve the user choices
	NSUInteger index = madelegate.index;
	NSString *answer = [[madelegate.text copy] autorelease];
	if (index == 0) answer = nil; // assumes cancel in position 0
	
	[alertView release];
	[madelegate release];
	return answer;
}

+ (NSString *)ask:(NSString *)question withTextPrompt:(NSString *)prompt
{
	return [CommonTools textQueryWith:question prompt:prompt button1:@"取消" button2:@"确定"];
}


+(NSString *)checkPrice:(id)price{
    double p = [price doubleValue];
    if (p==0.0) {
        return @"―";
    }else {
        return [NSString stringWithFormat:@"%.0f",p];
    }
}
@end
