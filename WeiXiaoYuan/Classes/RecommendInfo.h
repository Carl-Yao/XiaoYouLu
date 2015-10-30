//
//  RecommendInfo.h
//  WeiXiaoYuan
//
//  Created by 姚振兴 on 15/10/10.
//  Copyright © 2015年 Dukeland. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecommendInfo : NSObject
@property (nonatomic,strong)NSString* title;
@property (nonatomic,assign)NSInteger relatePersonNum;
@property (nonatomic,strong)NSString* imgUrl;
@property (nonatomic,strong)NSString* content;
@property (nonatomic,strong)NSString* date;
@end
