//
//  User.h
//  WeiXiaoYuan
//
//  Created by 姚振兴 on 15/1/27.
//  Copyright (c) 2015年 Dukeland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * feedbackID;
@property (nonatomic, retain) NSString * pushContent;
@property (nonatomic, retain) NSString * pushDate;
@property (nonatomic, retain) NSString * pushID;
@property (nonatomic, retain) NSString * pushImage;
@property (nonatomic, retain) NSString * pushSender;
@property (nonatomic, retain) NSString * pushTitle;
@property (nonatomic, retain) NSString * pushType;
@property (nonatomic, retain) NSString * userPic;

@end
