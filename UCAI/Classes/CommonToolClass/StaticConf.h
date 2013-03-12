//
//  StaticConf.h
//  JingDuTianXia
//
//  Created by Piosa on 11-10-10.
//  Copyright 2011 __JingDuTianXia__. All rights reserved.
//

#define API_VERSION	@"2.9.12"
#define TIME_OUT_SECONDS 10

#define UCAI_LOGIN_FILE_NAME @"ucai_login.plist"
#define UCAI_MEMBER_FILE_NAME @"ucai_member.plist"
#define UCAI_THEME_FILE_NAME @"ucai_theme.plist"

#define DOMAIN_PORT @"http://www.ucai.com:8080";

#define MEMBER_LOGIN_ADDRESS @"http://www.ucai.com:8080/PhonePort/member/memberLogin"                                       //用户登陆
#define MEMBER_REGISTER_ADDRESS @"http://www.ucai.com:8080/PhonePort/member/memberRegister"                                 //用户注册
#define MEMBER_PASSWORD_BACK_ADDRESS @"http://www.ucai.com:8080/PhonePort/member/memberPasswordBack"                        //用户登陆密码找回
#define MEMBER_INFO_QUERY_ADDRESS @"http://www.ucai.com:8080/PhonePort/member/memberInfoQuery"                              //用户资料查找
#define MEMBER_PHONE_VERIFY_ADDRESS @"http://www.ucai.com:8080/PhonePort/verify/phoneVerifySend"                            //用户手机号码认证码发送
#define MEMBER_INFO_MODIFY_ADDRESS @"http://www.ucai.com:8080/PhonePort/member/memberInfoModify"                            //用户资料修改
#define MEMBER_PASSWORD_MODIFY_ADDRESS @"http://www.ucai.com:8080/PhonePort/member/memberPasswordModify"                    //用户登陆密码修改
#define MEMBER_HISTORY_CUSTOMER_QUERY_ADDRESS @"http://www.ucai.com:8080/PhonePort/flight/FlightQueryUserHostory"           //常用乘机人查询
#define MEMBER_HISTORY_CUSTOMER_DELETE_ADDRESS @"http://www.ucai.com:8080/PhonePort/flight/FlightDelUserHostory"            //常用乘机人删除

#define HOTEL_SEARCH_ADDRESS @"http://www.ucai.com:8080/Global-Account/hotel!queryMulitHotel.do"                            //酒店列表查询
#define HOTEL_DETAIL_ADDRESS @"http://www.ucai.com:8080/Global-Account/hotel!querySingleHotel.do"                           //酒店详情查询
#define HOTEL_BOOK_ADDRESS @"http://www.ucai.com:8080/Global-Account/hotel!bookHotel.do"                                    //酒店预订
#define HOTEL_ORDERLIST_ADDRESS @"http://www.ucai.com:8080/Global-Account/hotel!hotelList.do"                               //酒店订单列表查询
#define HOTEL_ORDERDETAIL_ADDRESS @"http://www.ucai.com:8080/Global-Account/hotel!hotelDetail.do"                           //酒店订单详情查询

#define FLIGHT_RESERVE_ADDRESS @"http://www.ucai.com:8080/PhonePort/flight/flightReserve"                                   //机票预约接口
#define FLIGHT_LIST_SEARCH_ADDRESS @"http://www.ucai.com:8080/PhonePort/flight/flightSearch"                                //航班列表查询
#define FLIGHT_DETAIL_SEARCH_ADDRESS @"http://www.ucai.com:8080/PhonePort/flight/flightDetailSearch"                        //航班详情查询
#define FLIGHT_BOOKING_ADDRESS @"http://www.ucai.com:8080/PhonePort/flight/flightBooking"                                   //航班预定
#define FLIGHT_NOT_MEMBER_ORDERLIST_ADDRESS @"http://www.ucai.com:8080/PhonePort/flight/flightOrderQueryNotMember"			//非会员机票订单列表查询
#define FLIGHT_MEMBER_ORDERLIST_ADDRESS @"http://www.ucai.com:8080/PhonePort/member/memberFlightOrderQuery"                 //会员机票订单列表查询
#define FLIGHT_ORDERDETAIL_ADDRESS @"http://www.ucai.com:8080/PhonePort/flight/flightOrderQueryByNO"                        //机票订单详情查询
#define FLIGHT_ORDER_ALIPAY_ADDRESS @"http://www.ucai.com:8080/PhonePort/flight/trade?orderNo="                             //机票订单支付(支付宝wap支付)

#define COUPON_LIST_ADDRESS @"http://www.ucai.com:8080/PhonePort/coupon/couponListGet"                                      //优惠劵种类列表查询接口
#define COUPON_INFO_ADDRESS @"http://www.ucai.com:8080/PhonePort/coupon/couponInfoGet"                                      //优惠劵种类详情查询接口
#define COUPON_BOOK_ADDRESS @"http://www.ucai.com:8080/PhonePort/coupon/couponBooking"                                      //优惠劵下单接口
#define COUPON_ALIPAY_ADDRESS @"http://www.ucai.com:8080/PhonePort/coupon/alipayWapPay?orderNo="                            //优惠劵订单支付接口(支付宝wap支付)
#define COUPON_ORDERLIST_ADDRESS @"http://www.ucai.com:8080/PhonePort/coupon/couponOrderListQuery"                          //优惠劵订单列表查询接口
#define COUPON_ORDERINFO_ADDRESS @"http://www.ucai.com:8080/PhonePort/coupon/couponOrderInfoQuery"                          //优惠劵订单详情查询接口
#define COUPON_VALIDQUERY_ADDRESS @"http://www.ucai.com:8080/PhonePort/coupon/couponValidQuery"                             //优惠劵有效信息查询接口(站外优惠劵无法查询)
#define COUPON_SEND_ADDRESS @"http://www.ucai.com:8080/PhonePort/coupon/couponSend"                                         //优惠劵发送接口

#define PHONE_BILLRECHARGE_ADDRESS @"http://www.ucai.com:8080/PhonePort/recharge/phoneBillRecharge"                         //手机话费充值下单接口
#define PHONE_BILLRECHARGE_ALIPAY_ADDRESS @"http://www.ucai.com:8080/PhonePort/recharge/rechargeAlipayWapPay?orderNo="      //手机话费充值订单支付(支付宝wap支付)

#define ALLIN_TELPAY_ADDRESS @"http://www.ucai.com:8080/PhonePort/allin/allinTelPayTrade"                                   //通联电话支付

#define WEATHER_ADDRESS @"http://www.google.com/ig/api?hl=zh-cn&weather=,,,"                                                //天气查询

#define FEEDBACK_SUGGESTION_COMMIT_ADDRESS @"http://www.ucai.com:8080/PhonePort/feedback/suggestionCommit"                  //投诉建议提交接口
#define FEEDBACK_SUGGESTION_QUERY_ADDRESS @"http://www.ucai.com:8080/PhonePort/feedback/suggestionQuery"                    //投诉建议提交接口

#define kUrlOfBase @"http://www.ucai.com"

#define kLineCode [kUrlOfBase stringByAppendingFormat:@"%@%@",@"/train/line_p.html?psize=100&page=1&tcode=",self.lineCode]

#define kUrlOfStation [[[kUrlOfBase stringByAppendingFormat:@"%@%@",@"/train/one_city_p.html?psize=15&scity=",self.stationName] stringByAppendingFormat:@"%@%@",@"&linetype=",(self.stationType==nil)?@"":self.stationType] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]

#define kUrlOfTrain [[[kUrlOfBase stringByAppendingFormat:@"%@%@",@"/train/city_to_city_p.html?psize=15&scity=",fromCityName] stringByAppendingFormat:@"%@%@",@"&ecity=",toCityName]stringByAppendingFormat:@"%@%@",@"&stime=",self.startedDateLabel.text]

#define kUrlOfTrainDetail [kUrlOfBase stringByAppendingFormat:@"%@%@",@"/train/line_p.html?psize=100&page=1&tcode=",trainCode]
typedef enum {
    UCAIFlightLineStyleSingle,  //单程类型
    UCAIFlightLineStyleDouble   //往返类型
} UCAIFlightLineStyle;

@interface StaticConf : NSObject {

}

@end
