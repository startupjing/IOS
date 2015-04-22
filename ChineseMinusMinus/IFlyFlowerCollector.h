//
//  IFlyFlowerCollector.h
//  siriTest
//
//  Created by Azure Hu on 4/11/15.
//  Copyright (c) 2015 Azure Hu. All rights reserved.
//

//
//  IFlyFlowerCollector.m
//  SunFlower
//


#import <Foundation/Foundation.h>

typedef enum  {
    Male = 1,
    Female = 2,
    Unknown = 0,
}IFlyGender;


#define SUNFLOWERNOTIFICATION @"SUNFLOWERNSNOTIFICATION"


 
 */
@interface IFlyFlowerCollector : NSObject


#pragma mark 开启统计


+ (void) SetAppid:(NSString*) appid;

#pragma mark 配置


+ (void) SetCaptureUncaughtException:(BOOL)value;


+ (void) SetDebugMode:(BOOL)flag;

+ (void) SetAutoLocation:(BOOL)flag;

+ (void) setChannelID:(NSString *) channel;

#pragma mark 根据需要选择使用

+ (void) SetGender:(IFlyGender)gender;


+ (void) SetAge:(int) age;

+ (void) SetUserId:(NSString *) userId;

#pragma mark 立即发送数据

+ (void) Flush;


#pragma mark 页面统计



+ (void) OnPageStart:(NSString *)pageName;


+ (void) OnPageEnd:(NSString *)pageName;



#pragma mark 事件统计


+ (void) OnEvent:(NSString *)eventId;


+ (void) OnEvent:(NSString *)eventId label:(NSString *)label;


+ (void) OnEvent:(NSString *)eventId paramDic:(NSDictionary *)dic;

+ (void) OnEventDuration:(NSString *)eventId duration:(long) duration;


+ (void) OnEventDuration:(NSString *)eventId label:(NSString *)label duration:(long) duration;


+ (void) OnEventDuration:(NSString *)eventId paramDic:(NSDictionary *)dic duration:(long) duration;


 
+ (void) OnBeginEvent:(NSString *)eventId;


+ (void) OnBeginEvent:(NSString *)eventId paramDic:(NSDictionary *)dic;


+ (void) OnEndEvent:(NSString *)eventId;

#pragma mark log

+ (void) onLog:(NSString *)businessType paramDic:(NSDictionary *)dic;


+ (void) onLog:(NSString *)businessType paramDic:(NSDictionary *)dic duration:(long) duration label:(NSString *)label;

#pragma mark 在线参数


+ (void) updateOnlineConfig;


+ (NSString *) getOnlineParams:(NSString *)key;


+ (BOOL) isJailbroken;

+ (BOOL) isPirated;

@end