//
//  DoresoRecorderUtils.m
//  MyRecorder
//
//  Created by LiuQingjie on 13-9-7.
//  Copyright (c) 2013年 LiuQingjie. All rights reserved.
//

#import "DoresoRecorderUtils.h"
#import "StatisticInfo.h"

@implementation DoresoRecorderUtils

+(NSString *)GetPhoneType{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char*)malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    if ([platform isEqualToString:@"iPhone1,1"])   return@"iPhone_1G";
    if ([platform isEqualToString:@"iPhone1,2"])   return@"iPhone_3G";
    if ([platform isEqualToString:@"iPhone2,1"])   return@"iPhone_3GS";
    if ([platform isEqualToString:@"iPhone3,1"])   return@"iPhone_4(YD,LT)";
    if ([platform isEqualToString:@"iPhone3,2"])   return @"iPhone_4(LT)";
    if ([platform isEqualToString:@"iPhone3,3"])   return @"iPhone_4(DX)";
    if ([platform isEqualToString:@"iPhone4,1"])   return @"iphone4S";
    if ([platform isEqualToString:@"iphone5,1"])   return @"iphone5(YD,LT)";
    if ([platform isEqualToString:@"iPhone5,2"])   return @"iphone5(YD,DX,LT)";
    
    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone_5c_(GSM)";
    if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone_5c_(GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone_5s_(GSM)";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone_5s_(GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone_6_Plus";
    if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone_6";
    
    if ([platform isEqualToString:@"iPod1,1"])     return@"iPod_Touch_1G";
    if ([platform isEqualToString:@"iPod2,1"])     return@"iPod_Touch_2G";
    if ([platform isEqualToString:@"iPod3,1"])     return@"iPod_Touch_3G";
    if ([platform isEqualToString:@"iPod4,1"])     return@"iPod_Touch_4G";
    if ([platform isEqualToString:@"iPod5,1"])     return@"iPod_Touch_5G";
    
    if ([platform isEqualToString:@"iPad1,1"])     return@"iPad_1";
    if ([platform isEqualToString:@"iPad2,1"])     return@"iPad_2_(WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])     return@"iPad_2_(GSM)";
    if ([platform isEqualToString:@"iPad2,3"])     return@"iPad_2_(CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])     return@"iPad_2_(32nm)";
    if ([platform isEqualToString:@"iPad2,5"])     return@"iPad_mini(WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])     return@"iPad_mini(GSM)";
    if ([platform isEqualToString:@"iPad2,7"])     return@"iPad_mini(CDMA)";
    if ([platform isEqualToString:@"iPad3,1"])     return@"iPad_3_(WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])     return@"iPad_3_(CDMA)";
    if ([platform isEqualToString:@"iPad3,3"])     return@"iPad_3_(4G)";
    if ([platform isEqualToString:@"iPad3,4"])     return@"iPad_4_(WiFi)";
    if ([platform isEqualToString:@"iPad3,5"])     return@"iPad_4_(4G)";
    if ([platform isEqualToString:@"iPad3,6"])     return@"iPad_4_(CDMA)";
    if ([platform isEqualToString:@"i386"])        return@"Simulator";
    
    return platform;
}

+(int)GetCompress{//根据网络类型决定压缩参数，wifi:10,3G:8,2G:6
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *subviews = [[[app valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    UIView *dataNetworkItemView = nil;
    
    for (id subview in subviews) {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            dataNetworkItemView = subview;
            break;
        }
    }
    
    NSNumber * num = [dataNetworkItemView valueForKey:@"dataNetworkType"];
    if (num == nil) {
        return 8;
    }else{
        
        int n = [num intValue];
        if (n == 0) {
            return 8;
        }else if (n == 1){
            return 6;
        }else if (n == 2){
            return 8;
        }else{
            return 10;
        }
        
    }
    return 10;
}

+(NSString *)GetAppVersion{
    
    return [StatisticInfo appVersion];
//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
//    return appCurVersion;
}
+(NSString*)UDID
{
    return [StatisticInfo udid];
}
+(NSString *)GetMacAddress{
    
    int                    mib[6];
	size_t                len;
	char                *buf;
	unsigned char        *ptr;
	struct if_msghdr    *ifm;
	struct sockaddr_dl    *sdl;
	
	mib[0] = CTL_NET;
	mib[1] = AF_ROUTE;
	mib[2] = 0;
	mib[3] = AF_LINK;
	mib[4] = NET_RT_IFLIST;
	
	if ((mib[5] = if_nametoindex("en0")) == 0) {
		printf("Error: if_nametoindex error/n");
		return NULL;
	}
	
	if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
		printf("Error: sysctl, take 1/n");
		return NULL;
	}
	
	if ((buf = (char *)malloc(len)) == NULL) {
		printf("Could not allocate memory. error!/n");
		return NULL;
	}
	
	if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
		printf("Error: sysctl, take 2");
		return NULL;
	}
	
	ifm = (struct if_msghdr *)buf;
	sdl = (struct sockaddr_dl *)(ifm + 1);
	ptr = (unsigned char *)LLADDR(sdl);
	NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
	free(buf);
	return [outstring uppercaseString];
	
}

//+(void)WriteDataToFile:(NSMutableData *)data{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSLog(@"path-----%@",paths);
//    NSString *documentDirectory = [paths objectAtIndex:0];
//    NSLog(@"documentDiretory-----%@",documentDirectory);
//    NSString *filePath = [documentDirectory stringByAppendingPathComponent:@"myfile"];
//    NSLog(@"filepath-----%@",filePath);
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    if ([fileManager fileExistsAtPath:filePath]) {
//        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
//    }
//    if(data != nil)
//    [data writeToFile:filePath atomically:YES];
//}
//
//+(NSData *)ReadDataFromFile:(NSString *)name{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentDirectory = [paths objectAtIndex:0];
//    NSString* fileName = [documentDirectory stringByAppendingPathComponent:name];
//    NSLog(@"%@",fileName);
////    NSString* getMyText = [NSString stringWithContentsOfFile:fileName usedEncoding:NULL error:NULL];
////    NSLog(@"%@, %d", getMyText, getMyText.length);
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    if ([fileManager fileExistsAtPath:fileName]) {
////        [fileManager createFileAtPath:fileName contents:nil attributes:nil];
//        NSLog(@"data not null");
//        NSData *data = [NSData dataWithContentsOfFile:fileName];
//        NSLog(@"datalength---%d",[data length]);
//        return data;
//    }
//    return nil;
//}
@end
