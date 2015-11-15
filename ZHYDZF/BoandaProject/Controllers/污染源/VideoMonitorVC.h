//
//  VideoMonitorVC.h
//  BoandaProject
//
//  Created by PowerData on 14-6-19.
//  Copyright (c) 2014年 szboanda. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PLATFORM_LOGIN_USERNAME					"username"
#define PLATFORM_LOGIN_PASSWORD					"password"
#define PLATFORM_LOGIN_WIDTH					"width"
#define PLATFORM_LOGIN_HEIGHT					"height"
#define PLATFORM_LOGIN_NETTYPE					"netType"
#define PLATFORM_LOGIN_DECODERCAPBILITY			"decoderCapbility"
#define PLATFORM_LOGIN_VERSION					"version"

#define PLATFORM_URL_USERID						"userID"
#define PLATFORM_URL_DEVICEID					"deviceID"
#define PLATFORM_URL_CHANNEL					"channel"
#define PLATFORM_URL_PUID_CHANNELNO				"puID_ChannelNo"
#define PLATFORM_URL_STREAMTYPE					"streamType"
#define PLATFORM_URL_NETTYPE					"netType"
#define PLATFORM_URL_STREAMENCODING				"streamEncoding"
#define PLATFORM_URL_PLATFORMID					"platformID"
#define PLATFORM_URL_ACSIP						"acsip"
#define PLATFORM_URL_ACSPORT					"acsport"
#define PLATFORM_URL_ACSUSR						"acsusr"
#define PLATFORM_URL_ACSPWD						"acspwd"
#define PLATFORM_URL_PTZCONTROL					"ptzControl"
#define PLATFORM_URL_CHANNELNAME				"channelName"
#define PLATFORM_URL_USRTYPE					"usrType"

#define PLATFORM_LOGIN_BASEURL					"/service/dvrs_mcu.php?"		// 登录URL
#define PLATFORM_NETTYPE_2G						0								// 网络类型2g
#define PLATFORM_NETTYPE_3G						1								// 网络类型3g
#define PLATFORM_NETTYPE_UDP					0								// UDP request
#define PLATFORM_NETTYPE_TCP					1								// TCP request
#define PLATFORM_WEB_WIDTH						320
#define PLATFORM_WEB_HEIGHT						390
#define PLATFORM_VERSION						"V2.00.00"						// 客户端版本

#define PLATFORM_DECODER_HIK264					0X00000001						// 解码能力HK264
#define PLATFORM_DECODER_AVC264					0X00000010						// 解码能力AVC264

#define STREAMENCODING_3GPP_H264				0x00000001						// 编码类型3gpp 264
#define STREAMENCODING_HIK_HK264				0X00000000						// 编码类型HK 264
@interface VideoMonitorVC : UIViewController

@end
