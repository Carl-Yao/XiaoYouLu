//
//  DoresoRecorderUtils.h
//  MyRecorder
//
//  Created by LiuQingjie on 13-9-7.
//  Copyright (c) 2013年 LiuQingjie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CFNetwork/CFNetwork.h>
#import <UIKit/UIKit.h>
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

@interface DoresoRecorderUtils : NSObject

+(NSString *)GetPhoneType;

+(int)GetCompress;

+(NSString *)GetAppVersion;

+(NSString*)UDID;
+(NSString *)GetMacAddress;

//+(void)WriteDataToFile :(NSMutableData *)data;
//
//+(NSData *)ReadDataFromFile :(NSString *)name;
@end
